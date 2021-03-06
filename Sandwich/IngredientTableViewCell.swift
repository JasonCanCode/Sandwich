//
//  IngredientTableViewCell.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import RxSwift

class IngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!

    private var imageDisposable: Disposable?

    func configure(with viewModel: IngredientCellModel) {
        removeExpiredObservables()

        nameLabel.text = viewModel.name
        nameLabel.textColor = viewModel.textColor

        imageDisposable = viewModel.thumbnailImage
            .asObservable()
            .subscribe(onNext: { image in
                self.thumbnailImageView.image = image
            })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        checkImageView.isHidden = !selected
    }

    deinit {
        removeExpiredObservables()
    }

    private func removeExpiredObservables() {
        imageDisposable?.dispose()
    }

}
