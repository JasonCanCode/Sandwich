//: [Previous](@previous)

import RxSwift

example(of: "DisposeBag") {

    // 1
    let disposeBag = DisposeBag()

    // 2
    Observable.of("A", "B", "C")
        .subscribe { // 3
            print($0)
        }
        .addDisposableTo(disposeBag) // 4
}

//: [Next](@next)
