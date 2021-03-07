//
//  DetailCharacterViewController.swift
//  Marvel
//
//  Created by Jorge on 07/03/2021.
//

import UIKit

final class DetailCharacterViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var storiesLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var model: MarvelModel?
    var idCharacterModel: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }

    // MARK: - Private functions

    private func setupData() {
        guard let id = idCharacterModel else { return }

        model?.characterNetwork(id: id) { [weak self] result in
            switch result {
            case .success(let charactersModel):
                self?.model?.setSelectedCharacter(charactersModel)
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
    }

}
