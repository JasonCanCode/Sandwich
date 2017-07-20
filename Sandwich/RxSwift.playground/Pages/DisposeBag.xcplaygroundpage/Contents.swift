//: [⬅️](@previous)
import RxSwift
/*:
 Use a Bag
 ======
 */

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()

    Observable.of("A", "B", "C")
        .subscribe { // 3
            print($0)
        }.addDisposableTo(disposeBag)
}

//: [➡️](@next)
