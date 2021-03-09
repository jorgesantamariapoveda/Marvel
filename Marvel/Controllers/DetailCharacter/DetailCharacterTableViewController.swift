//
//  DetailCharacterTableViewController.swift
//  Marvel
//
//  Created by Jorge on 09/03/2021.
//

import UIKit

final class DetailCharacterTableViewController: UITableViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var numComicsLabel: UILabel!
    @IBOutlet weak var numSeriesLabel: UILabel!
    @IBOutlet weak var numStoriesLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var idCharacterModel: Int?
    private var model: CharacterModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    // MARK: - Private functions

    private func setupData() {
        guard let id = idCharacterModel else { return }

        getCharacterAPI(id: id) { [weak self] result in
            switch result {
            case .success(let characterResponse):
                self?.model = CharacterModel(characterResponse: characterResponse)
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
        numComicsLabel.text = model?.getNumComics()
        numSeriesLabel.text = model?.getNumSeries()
        numStoriesLabel.text = model?.getNumStories()
        descriptionTextView.text = model?.getDescription()
        avatar.layer.cornerRadius = 8

        if let url = model?.getUrlAvatar(size: .big) {
            getImageNetwork(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.avatar.image = image
                }
            }
        }
    }

}
