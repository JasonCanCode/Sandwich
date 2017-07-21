//: [⬅️](@previous)

import RxSwift
/*:
 Simple Observables
 =====
 */

let one = 1
let two = 2
let three = 3


example(of: "just") {
    let observable: Observable<Int> = Observable<Int>.just(one)

    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)")
    })
}

example(of: "of (sequence)") {
    let observable = Observable.of(one, two, three)

    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)")
    })
}

example(of: "of (array)") {
    let observable = Observable.of([one, two, three])

    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)")
    })
}

example(of: "from (array)") {
    let observable = Observable.from([one, two, three])

    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)")
    })
}

//: [➡️](@next)
