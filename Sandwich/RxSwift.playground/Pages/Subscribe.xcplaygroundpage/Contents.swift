//: [Previous](@previous)

import RxSwift

example(of: "subscribe") {

    let one = 1
    let two = 2
    let three = 3

    let observable = Observable.of(one, two, three)

    observable.subscribe(onNext: { element in
        print(element)
    })
}

//: [Next](@next)
