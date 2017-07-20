//: [⬅️](@previous)
import RxSwift
/*:
 Observables
 ======
 The Producers
 ------

 * Allows classes to subscribe for emitted values over time.
     * More efficient than Notification Center
 * Must be typed when used (when it can't be inferred)
 */
let simpleObs = Observable.just(5)
let typedObs = Observable<Float>.just(5)


//: [➡️](@next)
