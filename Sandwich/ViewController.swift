//
//  ViewController.swift
//  Sandwich
//
//  Created by Jason Welch on 7/14/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let ingImages = [
            #imageLiteral(resourceName: "bread"),
            #imageLiteral(resourceName: "cheese_level"),
            #imageLiteral(resourceName: "cheese_askew"),
            #imageLiteral(resourceName: "cucumber"),
            #imageLiteral(resourceName: "ham"),
            #imageLiteral(resourceName: "jelly"),
            #imageLiteral(resourceName: "lettuce"),
            #imageLiteral(resourceName: "peanut_butter"),
            #imageLiteral(resourceName: "tomato_slice"),
            #imageLiteral(resourceName: "bread")
        ]

        let observable = Observable<UIImage>.from(ingImages)
        observable.subscribe(onNext: { img in
            let ingView = self.ingredientView(withImage: img)
            self.addIngredient(view: ingView)
        }).addDisposableTo(disposeBag)

        let breadImageView = UIImageView(image: #imageLiteral(resourceName: "bread"))
        breadImageView.contentMode = .scaleToFill
        addIngredient(view: breadImageView)
    }

    func ingredientView(withImage image: UIImage) -> UIView {
        let ingImageView = UIImageView(image: image)
        ingImageView.contentMode = .scaleToFill
        
        return ingImageView
    }

    func addIngredient(view ingView: UIView) {
        ingView.alpha = 0
        view.addSubview(ingView)
        sizeAndCenter(view: ingView, in: self.view)

        UIView.animate(withDuration: 1.0, animations: {
            ingView.alpha = 1
        }, completion: { _ in

        })
    }

    func sizeAndCenter(view subview: UIView, in superview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        subview.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true
        subview.heightAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true

        superview.setNeedsUpdateConstraints()
    }
}

