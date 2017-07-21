//: [⬅️](@previous)
import RxSwift
/*:
 Disposable
 ======
 */

example(of: "dispose") {

    let observable = Observable.of("A", "B", "C")

    let subscription: Disposable = observable.subscribe { event in
        print(event)
    }
    subscription.dispose()
}

//: [➡️](@next)
