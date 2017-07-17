//
//  SandwichType.swift
//  Sandwich
//
//  Created by Jason Welch on 7/14/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit

enum CraftingError: Error {
    case invalidIngredients
}

enum SandwichType {
    case    ham,
            veggie,
            breakfast,
            pbj,
            cheese

    var title: String {
        switch self {
        case .ham:
            return "Ham"
        case .veggie:
            return "Veggie"
        case .breakfast:
            return "Breakfast"
        case .pbj:
            return "Peanut Butter and Jelly"
        case .cheese:
            return "Cheese"
        }
    }

    var ingredientNames: [String] {
        switch self {
        case .ham:
            return [
                "cheese",
                "ham",
                "lettuce",
                "tomato_slice"
            ]
        case .veggie:
            return [
                "cucumber",
                "lettuce",
                "tomato_slice"
            ]
        case .breakfast:
            return [
                "cheese",
                "egg",
                "lettuce",
                "tomato_slice"
            ]
        case .pbj:
            return [
                "jelly",
                "peanut_butter"
            ]
        case .cheese:
            return [
                "cheese"
            ]
        }
    }

    private func isCorrectIngredients(_ ingredients: [Ingredient]) -> Bool {
        let ingredientNames = ingredients.map { $0.name }
        return Set(self.ingredientNames).symmetricDifference(Set(ingredientNames)).isEmpty
    }

    static func craft(from ingredients: [Ingredient]) throws -> SandwichType {
        let sandwichTypes: [SandwichType] = [.ham,
                                             .veggie,
                                             .breakfast,
                                             .pbj,
                                             .cheese]

        if let matchingType = sandwichTypes.lazy.filter({ $0.isCorrectIngredients(ingredients) }).first {
            return matchingType
        } else {
            throw CraftingError.invalidIngredients
        }
    }
}
