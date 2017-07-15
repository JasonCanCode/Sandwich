//
//  SandwichType.swift
//  Sandwich
//
//  Created by Jason Welch on 7/14/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit

enum SandwichType {
    case bologna, veggie, breakfast, pbj, cheese

    var image: UIImage {
        switch self {
        case .bologna:
            return #imageLiteral(resourceName: "bologna")
        case .veggie:
            return #imageLiteral(resourceName: "veggie")
        case .breakfast:
            return #imageLiteral(resourceName: "breakfast")
        case .pbj:
            return #imageLiteral(resourceName: "pbj")
        case .cheese:
            return #imageLiteral(resourceName: "cheese")
        }
    }
}
