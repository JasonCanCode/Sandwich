//: [⬅️](@previous)

import RxSwift

example(of: "just, of, from") {

    // 1
    let one = 1
    let two = 2
    let three = 3

    // 2
    let observable1: Observable<Int> = Observable<Int>.just(one)
    let observable2 = Observable.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    let observable4 = Observable.from([one, two, three])

    print("just...")
    observable1.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)\n")
    })
    print("of (sequence)...")
    observable2.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)\n")
    })
    print("of (array)...")
    observable3.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)\n")
    })
    print("from (array)...")
    observable4.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("(completed)\n")
    })
}

//: [➡️](@next)
