//: [⬅️](@previous)

import RxSwift

example(of: "deferred") {

    let disposeBag = DisposeBag()

    // 1
    var flip = false

    // 2
    let factory: Observable<Int> = Observable.deferred {

        // 3
        flip = !flip

        // 4
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }

    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
            .addDisposableTo(disposeBag)
        
        print()
    }
    
}

//: [➡️](@next)
