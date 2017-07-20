//: [⬅️](@previous)
import RxSwift

let one = 1
let two = 2
let three = 3

let observable = Observable.of(one, two, three)

/*:
 Subscribers
 =====
 The Consumers
 -----
 */
example(of: "subscribe events") {
    observable.subscribe { event in
        print("Event", event)
        if let element = event.element {
            print("Element:", element)
        }
    }
}
 /*:
 * Repeated execution of block whenever value emitted
     * `onNext` block
 * Error handling
     * `onError` used to provide error response
     * are thrown, use `throw` in a func that returns an Observable
 * Deffered code
     * `onComplete` block for when the Observer finishs emitting
     * `onDispose` block for all-case cleanup
     * Once it is terminated, no more events
 */
example(of: "subscribe convenience") {
    observable.subscribe(onNext: { element in
        print("Next element:", element)
    }, onError: { error in
        print("Error:", error)
    }, onCompleted: {
        print("Subscription Complete")
    }, onDisposed: {
        print("Observer Disposed")
    })
}

//: [➡️](@next)
