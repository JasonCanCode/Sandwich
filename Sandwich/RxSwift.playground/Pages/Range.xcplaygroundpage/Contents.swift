//: [⬅️](@previous)
import RxSwift
/*:
 Range
 ======
 An example of excess
 ------
 */

func fibonacci(from i: Int) -> Int {
    let n = Double(i)
    let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) /
        2.23606).rounded())
    return fibonacci
}

example(of: "Range Observable") {
    let observable = Observable<Int>.range(start: 1, count: 10)

    observable.subscribe(onNext: { i in
        print(fibonacci(from: i))
    })
}







example(of: "Range Simplified") {
    for i in 1...10 {
        print(fibonacci(from: i))
    }
}

//: [➡️](@next)
