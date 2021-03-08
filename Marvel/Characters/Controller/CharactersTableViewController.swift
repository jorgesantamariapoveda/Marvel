//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Jorge on 03/03/2021.
//

import UIKit

final class CharactersTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var model = MarvelModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

        setupData()
    }

    // MARK: - Private functions

    private func setupData() {
        getCharactersNetwork { [weak self] result in
            switch result {
            case .success(let charactersResponse):
                self?.model.setCharacters(charactersResponse)
                DispatchQueue.main.async {
                    self?.setupUI()
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

    private func setupUI() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numCharacters()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCharacters", for: indexPath) as? CharactersTableViewCell else {
            return UITableViewCell()
        }

        cell.nameLabel.text = model.nameCharacterByIndex(indexPath.row)
        
        if let id = model.idCharacter(index: indexPath.row) {
            model.getImageMarvelNetwork(id: id, size: .small) {
                cell.avatar.image = $0
                cell.avatar.layer.cornerRadius = 8
                cell.setNeedsUpdateConfiguration()
            }
        }

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let detailVC = segue.destination as? DetailCharacterViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                detailVC.model = model
                detailVC.idCharacterModel = model.idCharacter(index: indexPath.row)
            }
        }
    }

}
