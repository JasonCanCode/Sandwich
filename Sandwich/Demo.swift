//
//  Demo.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import RxSwift

struct Demo {
    static var ingredients: [Ingredient] {
        let matchingTitleAndImageNames = [
            "cheese",
            "egg",
            "cucumber",
            "ham",
            "jelly",
            "lettuce",
            "peanut_butter",
            "tomato_slice"
            ]
        return matchingTitleAndImageNames.map { Ingredient(name: $0, image: $0) }
    }

    /// For loading SandwichVC from start
    static let testImages: [UIImage] = [
        #imageLiteral(resourceName: "cheese"),
        #imageLiteral(resourceName: "egg"),
        #imageLiteral(resourceName: "cucumber"),
        #imageLiteral(resourceName: "ham"),
        #imageLiteral(resourceName: "jelly"),
        #imageLiteral(resourceName: "lettuce"),
        #imageLiteral(resourceName: "peanut_butter"),
        #imageLiteral(resourceName: "tomato_slice")
    ]

    fileprivate static var imageDelay: TimeInterval = 0.5
}

// MARK: Network Mocking

enum NetworkError: Error {
    case invalidPath
}

typealias NetworkManager = Demo

extension Demo {
    /// To simulate a network layer
    static func fetchIngredients() -> Observable<[Ingredient]> {
        return simulateFetch(of: ingredients, delay: 2.5)
    }

    static func retrieveImage(withPath pretendPath: String) -> Observable<UIImage> {
        guard let image = UIImage(named: pretendPath) else {
            return Observable.error(NetworkError.invalidPath)
        }
        imageDelay += 0.08
        return simulateFetch(of: image, delay: imageDelay)
    }

    private static func simulateFetch<T>(of element: T, delay: TimeInterval) -> Observable<T> {
        return Observable.create { observer in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                observer.onNext(element)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
