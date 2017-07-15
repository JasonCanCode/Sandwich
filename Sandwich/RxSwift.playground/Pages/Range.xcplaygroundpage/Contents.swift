//: [⬅️](@previous)

import Foundation

example(of: "range") {

    // 1
    let observable = Observable<Int>.range(start: 1, count: 10)
    observable
        .subscribe(onNext: { i in
            // 2
            let n = Double(i)
            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) /
                2.23606).rounded())
            print(fibonacci)
        })
}

//: [➡️](@next)
