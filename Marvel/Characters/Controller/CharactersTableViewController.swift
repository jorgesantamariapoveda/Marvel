//
//  CharactersTableViewController.swift
//  Marvel
//
//  Created by Jorge on 03/03/2021.
//

import UIKit

final class CharactersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCharacters", for: indexPath)

        cell.textLabel?.text = "title"
        cell.detailTextLabel?.text = "detalle"
        cell.imageView?.image = UIImage(systemName: "person.fill")

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let detailVC = segue.destination as? DetailTableViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                detailVC.title = "Celda \(indexPath.row + 1)"
            }
        }
    }

}
