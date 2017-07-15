//: [Previous](@previous)

import RxSwift

example(of: "create") {

    enum MyError: Error {
        case anError
    }

    let disposeBag = DisposeBag()

    Observable<String>.create { observer in
        // 1
        observer.onNext("1")
        //observer.onError(MyError.anError)

        // 2
        //observer.onCompleted()

        // 3
        observer.onNext("?")

        // 4
        return Disposables.create()
        }
        .subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        )
        .addDisposableTo(disposeBag)
}

//: [Next](@next)
