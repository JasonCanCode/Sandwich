//: [⬅️](@previous)

import RxSwift

example(of: "dispose") {

    // 1
    let observable = Observable.of("A", "B", "C")

    // 2
    let subscription = observable.subscribe { event in

        // 3
        print(event)
    }
    subscription.dispose()
}

//: [➡️](@next)
