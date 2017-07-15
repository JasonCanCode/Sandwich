//: [⬅️](@previous)
/*:
_Don't forget to build the scheme first_
*/
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

//: [➡️](@next)
