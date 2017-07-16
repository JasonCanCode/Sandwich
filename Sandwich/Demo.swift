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
}
