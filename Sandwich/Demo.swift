//
//  Demo.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit

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

    /// To simulate a network layer
    static func fetchIngredients() -> [Ingredient] {
        // TODO: Make async
        return ingredients
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
}
