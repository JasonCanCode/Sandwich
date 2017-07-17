//
//  IngredientCellModel.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIImageColors

struct IngredientCellModel {
    let name: String
    let image: UIImage
    let textColor: UIColor
    let entity: Ingredient

    init(ingredient: Ingredient) {
        self.entity = ingredient
        self.name = IngredientCellModel.properName(from: ingredient.name)
        let image = UIImage(named: ingredient.image)!
        self.image = image
        textColor = image.getColors().primaryColor
    }

    private static func properName(from rawName: String) -> String {
        let nameElements = rawName.components(separatedBy: "_")
        let capitalizedElements = nameElements.map { $0.capitalized }

        return capitalizedElements.reduce("", { "\($0)\($1) " })
    }
}
