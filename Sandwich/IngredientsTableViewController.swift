//
//  IngredientsTableViewController.swift
//  Sandwich
//
//  Created by Jason Welch on 7/16/17.
//  Copyright © 2017 JasonCanCode. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    let ingredients = Demo.ingredients

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        updateMakeButton()
    }

    fileprivate func updateMakeButton() {
        navigationItem.rightBarButtonItem?.isEnabled = tableView.indexPathsForSelectedRows?.isEmpty == false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sandwichVC = segue.destination as? SandwichViewController,
            let selectedIndredients = getSelectedIngredients() else {
                return
        }
        let images = selectedIndredients.flatMap { UIImage(named: $0.image) } // FIXME: needs VM
        sandwichVC.configure(withIngredientImages: images)
    }
}

// MARK: - Table view data source
extension IngredientsTableViewController{

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
        let ingredient = ingredients[indexPath.row]

        cell.nameLabel.text = ingredient.name
        cell.thumbnailImageView.image = UIImage(named: ingredient.image) // FIXME: needs VM

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateMakeButton()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateMakeButton()
    }

    fileprivate func getSelectedIngredients() -> [Ingredient]? {
        guard let selectedRows = tableView.indexPathsForSelectedRows?.map({ $0.row }),
            !selectedRows.isEmpty else {
                return nil
        }
        let selectedIngredients = selectedRows.map { self.ingredients[$0] }
        return selectedIngredients
    }
    
}
