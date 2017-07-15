//: [⬅️](@previous)

import RxSwift

example(of: "never") {

    let observable = Observable<Any>.never()
    observable
        .subscribe(
            onNext: { element in
                print(element)
        },
            onCompleted: {
                print("Completed")
        }
    )
}

//: [➡️](@next)
