//
//  IngredientCellModel.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import UIImageColors
import RxSwift
import RxRelay

struct IngredientCellModel {
    let name: String
    let textColor: UIColor
    let thumbnailImage = BehaviorRelay<UIImage?>(value: nil)
    let imagePath: String

    init(ingredient: Ingredient) {
        self.name = IngredientCellModel.properName(from: ingredient.name)
        let image = UIImage(named: ingredient.image)!
        textColor = image.getColors()!.primary
        self.imagePath = ingredient.image
    }

    private static func properName(from rawName: String) -> String {
        let nameElements = rawName.components(separatedBy: "_")
        let capitalizedElements = nameElements.map { $0.capitalized }

        return capitalizedElements.reduce("", { "\($0)\($1) " })
    }
}
