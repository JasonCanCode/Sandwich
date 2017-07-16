//
//  ViewController.swift
//  Sandwich
//
//  Created by Jason Welch on 7/14/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import RxSwift

private let kFadeInDuration: TimeInterval = 1.0

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    let testImages = [
        #imageLiteral(resourceName: "cheese_level"),
        #imageLiteral(resourceName: "egg"),
        #imageLiteral(resourceName: "cucumber"),
        #imageLiteral(resourceName: "ham"),
        #imageLiteral(resourceName: "jelly"),
        #imageLiteral(resourceName: "lettuce"),
        #imageLiteral(resourceName: "peanut_butter"),
        #imageLiteral(resourceName: "tomato_slice")
    ]

    var ingImages: [UIImage] = []

    func configure(withIngredientImages images: [UIImage]) {
        var allImages = [#imageLiteral(resourceName: "bread")]
        allImages.append(contentsOf: images)
        allImages.append(#imageLiteral(resourceName: "bread"))

        ingImages = allImages
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure(withIngredientImages: testImages)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        assembleSandwichOneAtATime() {
            AlertHelper.showSingleButtonAlert(in: self, title: "Eat Up", message: "Your sandwich is made")
        }
    }

    func assembleThatSandwich() {
        let observable = Observable<UIImage>.from(ingImages)

        observable.subscribe(onNext: { img in
            let ingView = self.ingredientView(withImage: img)
            self.addIngredient(view: ingView, to: self.view)

            UIView.animate(withDuration: kFadeInDuration) {
                ingView.alpha = 1
            }
        }).addDisposableTo(disposeBag)
    }

    func ingredientView(withImage image: UIImage) -> UIView {
        let ingImageView = UIImageView(image: image)
        ingImageView.contentMode = .scaleToFill
        
        return ingImageView
    }

    func addIngredient(view ingView: UIView, to superview: UIView) {
        ingView.alpha = 0
        superview.addSubview(ingView)
        sizeAndCenter(view: ingView, in: self.view)
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


















extension ViewController {

    func assembleSandwichOneAtATime(completion: @escaping (Void) -> Void) {
        let ingredientObs = ingImages.map { self.observableForIngredientAddition(withImage: $0) }
        Observable.from(ingredientObs)
            .concat()
            .subscribe(onCompleted: {
                completion()
            })
            .addDisposableTo(disposeBag)
    }

    func observableForIngredientAddition(withImage image: UIImage) -> Observable<Void> {
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


















extension ViewController {

    func assembleSandwichOneAtATime() {
        let ingredientObs = ingImages.map { self.observableForIngredientAddition(withImage: $0) }
        Observable.from(ingredientObs)
            .concat()
            .publish()
            .connect()
            .addDisposableTo(disposeBag)
    }
}

