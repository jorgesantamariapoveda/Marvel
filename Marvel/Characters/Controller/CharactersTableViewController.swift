//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Jorge on 03/03/2021.
//

import UIKit

final class CharactersTableViewController: UITableViewController {

    var model = MarvelModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numCharacters()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCharacters", for: indexPath)

        cell.textLabel?.text = model.nameCharacterByIndex(indexPath.row)
        cell.detailTextLabel?.text = model.descriptionCharacter(index: indexPath.row)
        cell.imageView?.image = UIImage(systemName: "person.fill")

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let detailVC = segue.destination as? DetailTableViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                detailVC.model = model
                detailVC.idCharacterModel = model.idCharacter(index: indexPath.row)
            }
        }
    }

}
