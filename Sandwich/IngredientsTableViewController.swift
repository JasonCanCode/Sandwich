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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        updateMakeButton()
    }

    private func updateMakeButton() {
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredient = ingredients[indexPath.row]

        cell.textLabel?.text = ingredient.name
        cell.imageView?.image = UIImage(named: ingredient.image) // FIXME: needs VM
        cell.imageView?.contentMode = .scaleAspectFit

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        updateMakeButton()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none

        updateMakeButton()
    }

    private func getSelectedIngredients() -> [Ingredient]? {
        guard let selectedRows = tableView.indexPathsForSelectedRows?.map({ $0.row }),
            !selectedRows.isEmpty else {
                return nil
        }
        let selectedIngredients = selectedRows.map { self.ingredients[$0] }
        return selectedIngredients
    }
    
}
