//
//  SimpleSandwichFactory.swift
//  Sandwich
//
//  Created by Jason Welch on 7/14/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import Foundation

enum CraftingError: Error {
    case invalidIngredients
}

struct SimpleSandwichFactory {

    static func craft(from ingredients: [String]) throws -> SandwichType {

        if ingredients.contains("cheese") {
            return craftCheeseSandwich(from: ingredients)
        } else if ingredients.contains("lettuce"),
            ingredients.contains("tomato"),
            ingredients.contains("egg") {

            return .breakfast
        } else if ingredients.contains("peanut_butter"),
            ingredients.contains("jelly") {

            return .pbj
        }
        throw CraftingError.invalidIngredients
    }

    private static func craftCheeseSandwich(from ingredients: [String]) -> SandwichType {
        if ingredients.contains("lettuce"),
            ingredients.contains("tomato") {

            if ingredients.contains("ham") {
                return .ham
            } else if ingredients.contains("cucumber") {
                return .veggie
            }
        }

        return .cheese
    }
}
