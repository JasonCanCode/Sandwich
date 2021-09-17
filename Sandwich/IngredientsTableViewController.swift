//
//  IngredientsTableViewController.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit
import RxSwift

class IngredientsTableViewController: UITableViewController, LoadingOverlayDisplayable {
    var loadingOverlayView: LoadingOverlayView?
    let disposeBag = DisposeBag()
    var cellVMs: [IngredientCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        addLoadingOverlay(to: navigationController!.view)
        updateIngredients()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        updateMakeButton()
    }

    fileprivate func updateMakeButton() {
        navigationItem.rightBarButtonItem?.isEnabled = tableView.indexPathsForSelectedRows?.isEmpty == false
    }

    private func updateIngredients() {
        updateLoadingSpinner(isLoading: true)

        NetworkManager.fetchIngredients()
            .subscribe(onNext: { ingredients in
                self.updateViewModels(with: ingredients)
            }, onError: { error in
                self.updateViewModels(with: [])
                AlertHelper.showAlert(for: error, in: self)
            }, onDisposed: {
                self.updateLoadingSpinner(isLoading: false)
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

    private func updateViewModels(with ingredients: [Ingredient]) {
        cellVMs = ingredients.map { IngredientCellModel(ingredient: $0) }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sandwichVC = segue.destination as? SandwichViewController,
            let selectedIngredientImages = getSelectedIngredientImages() else {
                return
        }
        sandwichVC.configure(withIngredientImages: selectedIngredientImages)
    }
}

// MARK: - Table view data source
extension IngredientsTableViewController{

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellVMs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
        let cellViewModel = cellVMs[indexPath.row]
        cell.configure(with: cellViewModel)

        NetworkManager.retrieveImage(withPath: cellViewModel.imagePath)
            .subscribe(onNext: { image in
                cellViewModel.thumbnailImage.accept(image)
            })
//            .bind(to: cellViewModel.thumbnailImage)
            .disposed(by: disposeBag)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateMakeButton()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateMakeButton()
    }

    fileprivate func getSelectedIngredientImages() -> [UIImage]? {
        guard let selectedRows = tableView.indexPathsForSelectedRows?.map({ $0.row }),
            !selectedRows.isEmpty else {
                return nil
        }
        let selectedIngredients = selectedRows.compactMap { self.cellVMs[$0].thumbnailImage.value }
        return selectedIngredients
    }
    
}
