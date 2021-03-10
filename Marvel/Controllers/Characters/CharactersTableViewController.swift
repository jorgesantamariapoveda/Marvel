//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Jorge on 03/03/2021.
//

import UIKit

final class CharactersTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var model: CharactersModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

        setupData()
    }

    // MARK: - Private functions

    private func setupData() {
        getCharactersAPI { [weak self] result in
            switch result {
            case .success(let charactersResponse):
                self?.model = CharactersModel(charactersResponse: charactersResponse)
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
        model?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCharacters", for: indexPath) as? CharactersTableViewCell else {
            return UITableViewCell()
        }

        if let model = model,
           let character = model.getCharacter(index: indexPath.row) {
            cell.setupData(character: character)
        }

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCharacter" {
            if let detailCharacterTableViewController = segue.destination as? DetailCharacterTableViewController,
               let indexPath = tableView.indexPathForSelectedRow,
               let character = model?.getCharacter(index: indexPath.row)  {
                detailCharacterTableViewController.idCharacterModel = character.getId()
            }
        }
    }

}
