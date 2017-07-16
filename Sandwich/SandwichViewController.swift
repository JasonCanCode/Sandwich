//
//  SandwichViewController.swift
//  Sandwich
//
//  Created by Jason Welch on 7/14/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import RxSwift

private let kFadeInDuration: TimeInterval = 1.0

class SandwichViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    fileprivate var ingImages: [UIImage] = []

    func configure(withIngredientImages images: [UIImage]) {
        var allImages = [#imageLiteral(resourceName: "bread")]
        allImages.append(contentsOf: images)
        allImages.append(#imageLiteral(resourceName: "bread"))

        ingImages = allImages
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        assembleSandwichOneAtATime() {
            self.finishSandwich()
        }
    }

    // [1]
    fileprivate func assembleSandwich() {
        let observable = Observable<UIImage>.from(ingImages)

        observable.subscribe(onNext: { img in
            let ingView = self.ingredientView(withImage: img)
            self.addIngredient(view: ingView, to: self.view)

            UIView.animate(withDuration: kFadeInDuration) {
                ingView.alpha = 1
            }
        }).addDisposableTo(disposeBag)
    }

    fileprivate func ingredientView(withImage image: UIImage) -> UIView {
        let ingImageView = UIImageView(image: image)
        ingImageView.contentMode = .scaleToFill
        
        return ingImageView
    }

    fileprivate func addIngredient(view ingView: UIView, to superview: UIView) {
        ingView.alpha = 0
        superview.addSubview(ingView)
        sizeAndCenter(view: ingView, in: self.view)
    }

    fileprivate func sizeAndCenter(view subview: UIView, in superview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        subview.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true
        subview.heightAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true

        superview.setNeedsUpdateConstraints()
    }

    fileprivate func finishSandwich() {
        AlertHelper.showSingleButtonAlert(in: self, title: "Eat Up", message: "Your sandwich is made")
    }
}


















extension SandwichViewController {
    // [2]
    fileprivate func assembleSandwichOneAtATime(completion: @escaping (Void) -> Void) {
        let ingredientObs = ingImages.map { self.observableForIngredientAddition(withImage: $0) }
        Observable.from(ingredientObs)
            .concat()
            .subscribe(onCompleted: {
                completion()
            })
            .addDisposableTo(disposeBag)
    }

    fileprivate func observableForIngredientAddition(withImage image: UIImage) -> Observable<Void> {
        let ingView = self.ingredientView(withImage: image)
        addIngredient(view: ingView, to: view)

        return Observable.create { observer in
            UIView.animate(withDuration: kFadeInDuration, animations: {
                ingView.alpha = 1
            }, completion: { _ in
                observer.onCompleted()
            })

            return Disposables.create()
        }
    }
}


















extension SandwichViewController {
    // [3]
    fileprivate func assembleSandwichOneAtATime() {
        let ingredientObs = ingImages.map { self.observableForIngredientAddition(withImage: $0) }
        Observable.from(ingredientObs)
            .concat()
            .publish()
            .connect()
            .addDisposableTo(disposeBag)
    }
}













extension SandwichViewController {
    // [4]
    fileprivate func assembleSandwichOneAtATime(with ingredients: [UIImage], completion: @escaping (Void) -> Void) {
        guard !ingredients.isEmpty else {
            return
        }
        var remainingIngredients = ingredients
        let nextImageToShow = remainingIngredients.removeFirst()
        let ingView = self.ingredientView(withImage: nextImageToShow)
        self.addIngredient(view: ingView, to: self.view)

        UIView.animate(withDuration: kFadeInDuration, animations: {
            ingView.alpha = 1
        }, completion: { _ in
            if !remainingIngredients.isEmpty {
                self.assembleSandwichOneAtATime(with: remainingIngredients) { completion() }
            } else {
                completion()
            }
        })
    }
}

