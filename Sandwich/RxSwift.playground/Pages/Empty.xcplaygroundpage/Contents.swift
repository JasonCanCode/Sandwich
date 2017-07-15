//: [Previous](@previous)

import RxSwift

example(of: "empty") {

    let observable = Observable<Void>.empty()

    observable
        .subscribe(

            // 1
            onNext: { element in
                print(element)
        },

            // 2
            onCompleted: {
                print("Completed")
        }
    )
}

//: [Next](@next)
