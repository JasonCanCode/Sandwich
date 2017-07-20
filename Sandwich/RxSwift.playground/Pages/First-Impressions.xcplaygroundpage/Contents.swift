//: [⬅️](@previous)

/*:
 First Impression
 =====
 _"We use RxSwift for MVVM"_
 */






/*:
 The View Model
-----------------
 */
class DACLoginViewModel {
    let usernameValidation: Driver<DACInputValidationResult>
    let passwordValidation: Driver<DACInputValidationResult>

    let rememberUsername: Driver<Bool>

    let isSignInEnabled: Driver<Bool>

    let signingIn: Driver<Bool>

    let signedIn: Driver<Void>
    let signInError: Driver<DACError>

    let recoverPasswordUsername = Variable<String?>(nil)
    let recoverPasswordResult: Driver<DACResult<Bool>>


    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        rememberUsername: Driver<Bool>,
        signIn: Driver<Void>
        ),
         onboardingService: DACOnboardingAPI
        ) {
        self.rememberUsername = input.rememberUsername

        self.usernameValidation = input.username.map { username in
            return DACInputValidator.validateUsername(username)
        }

        self.passwordValidation = input.password.map { password in
            return DACInputValidator.validatePassword(password)
        }

        self.isSignInEnabled = Driver.combineLatest(self.usernameValidation, self.passwordValidation) { username, password in
            username.isValid && password.isValid
            }.distinctUntilChanged()

        let signingIn = DACActivityIndicator()
        self.signingIn = signingIn.asDriver()

        let loginCredentials = Driver.combineLatest(input.username, input.password, self.rememberUsername) { ($0, $1, $2) }

        let signInResult = input.signIn.withLatestFrom(loginCredentials)
            .flatMapLatest { (username, password, rememberUsername) in
                return onboardingService
                    .signIn(username: username, password: password, rememberUsername: rememberUsername)
                    .trackActivity(signingIn)
                    .asDriver(onErrorRecover: { error in
                        return Driver.just(DACResult.failure(.error(error)))
                    })
        }

        self.signedIn = signInResult.flatMapLatest { result in
            switch result {
            case .success():
                return Driver.just()
            case .failure:
                return Driver.empty()
            }
        }

        self.signInError = signInResult.flatMapLatest { result in
            switch result {
            case .success:
                return Driver.empty()
            case.failure(let error):
                return Driver.just(error)
            }
        }

        self.recoverPasswordResult = self.recoverPasswordUsername
            .asDriver()
            .flatMap({ username in
                if let username = username {
                    return onboardingService
                        .recoverPassword(username: username)
                        .trackActivity(signingIn)
                        .asDriver(onErrorRecover: { error in
                            return Driver.just(DACResult.failure(.error(error)))
                        })
                } else {
                    return Driver.just(DACResult.failure(.unknownError(description: "An unknown error has occurred. Please try again")))
                }
            })
    }
}



/*:
 The Service Layer
 -----------------
 */

class DACOnboardingService: DACBaseWebService, DACOnboardingAPI {
    func signIn(username: String, password: String, rememberUsername: Bool) -> Observable<DACResult<Void>> {
        let usernamePasswordParams = [kUserId: username, kPassword: password]

        let result = DACSessionManager.shared.request(withAPIPath: loginPath, parameters: usernamePasswordParams)

        return result
            .flatMap({ dataRequest -> Observable<DACResult<DACUser>> in
                _ = result.do(onDispose: {
                    dataRequest.cancel()
                })

                return dataRequest.rx.responseJSON()
                    .flatMap({ (response, json) -> Observable<DACResult<DACUser>> in
                        if let json = json as? [String: Any] {
                            if let resultCode = json[kResultCode] as? Int,
                                let message = json[kMessage] as? String {
                                if resultCode == 0 {
                                    if rememberUsername {
                                        UserDefaults.standard.set(username, forKey: kUsername)
                                    }

                                    let expirationDate = Calendar.current.date(byAdding: DateComponents(minute: 30), to: Date()) ?? Date()

                                    var user = DACUser(username: username, expirationDate: expirationDate)
                                    user.password = password

                                    return Observable.just(DACResult.success(user))
                                } else {
                                    return Observable.just(DACResult.failure(DACError.invalidParameterError(description: message)))
                                }
                            } else if let _ = json[kErrorCode] as? Int,
                                let errorMessage = json[kErrorMessage] as? String {
                                return Observable.just(DACResult.failure(.unknownError(description: errorMessage.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))))
                            } else {
                                return Observable.just(DACResult.failure(DACError.jsonSerializationError(description: "The JSON data returned is not in the correct format. Please try again.")))
                            }
                        } else {
                            return Observable.just(DACResult.failure(DACError.jsonSerializationError(description: "The JSON data returned is not in the correct format. Please try again.")))
                        }
                    })
            })
            .flatMap({ userResult -> Observable<DACResult<Void>> in
                switch userResult {
                case .success(let user):
                    var updatedUser = user

                    let buildingsResult = DACSessionManager.shared.request(withAPIPath: buildingListPath, parameters: usernamePasswordParams)

                    return buildingsResult
                        .flatMap({ dataRequest -> Observable<DACResult<Void>> in
                            _ = buildingsResult.do(onDispose: {
                                dataRequest.cancel()
                            })

                            return dataRequest.rx.responseJSON()
                                .flatMap({ (response, buildingsJSON) -> Observable<DACResult<Void>> in
                                    if let buildingsJSON = buildingsJSON as? [[String: Any]] {
                                        var buildingObservables = [Observable<DACResult<DACBuilding>>]()

                                        for building in buildingsJSON {
                                            if let buildingPk = building[kBuildingPk] as? String,
                                                let address = building[kAddress] as? String {
                                                let building = DACBuilding(buildingPk: buildingPk, address: address)
                                                buildingObservables.append(self._fetchBuildingData(forBuilding: building, username: username, password: password))
                                            }
                                        }

                                        if buildingObservables.count > 0 {
                                            return Observable.zip(buildingObservables) { buildingResults -> DACResult<Void> in
                                                var buildings = [DACBuilding]()

                                                for buildingResult in buildingResults {
                                                    switch buildingResult {
                                                    case .success(let building):
                                                        buildings.append(building)

                                                    case .failure(let error):
                                                        return DACResult.failure(.error(error))
                                                    }
                                                }

                                                updatedUser.buildings = buildings

                                                DACUser.currentUser = updatedUser

                                                return DACResult.success()
                                            }
                                        } else {
                                            updatedUser.buildings = [DACBuilding]()

                                            DACUser.currentUser = user

                                            return Observable.just(DACResult.success())
                                        }
                                    } else {
                                        return Observable.just(DACResult.failure(.jsonSerializationError(description: "The JSON data returned is not in the correct format. Please try again.")))
                                    }
                                })
                        })
                    
                case .failure(let error):
                    return Observable.just(DACResult.failure(.error(error)))
                }
            })
    }
}

//: [➡️](@next)
