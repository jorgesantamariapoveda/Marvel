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

        setupData()
    }

    private func setupData() {
        model.charactersNetwork { [weak self] result in
            switch result {
            case .success(let charactersModel):
                self?.model.updateCharactersModel(charactersModel)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error as MarvelError):
                switch error {
                case .statusCode(let statusCode):
                    print("Error Code: \(statusCode)")
                case.decoding:
                    print("Error in decoding")
                case .connectionError(let error):
                    print("Connection error: \(error.localizedDescription)")
                case .emptyData:
                    print("Empty data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numCharacters()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCharacters", for: indexPath)

        cell.textLabel?.text = model.nameCharacterByIndex(indexPath.row)
        cell.detailTextLabel?.text = model.descriptionCharacter(index: indexPath.row)

        if let id = model.idCharacter(index: indexPath.row) {
            model.imageNetwork(id: id, size: .small) {
                cell.imageView?.image = $0
                cell.setNeedsUpdateConfiguration()
            }
        }

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
