//
//  CharactersTableViewCell.swift
//  Marvel
//
//  Created by Jorge on 07/03/2021.
//

import UIKit

final class CharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func prepareForReuse() {
        avatar.image = nil
        nameLabel.text = nil
    }

    func setupData(character: CharacterModel) {
        nameLabel.text = character.getName()
        
        let imageInfo = character.getImageInfo()
        if let imageName = imageInfo.imageName,
           let imageExtension = imageInfo.imageExtension {
            if let image = loadImageCache(imageName: imageName, imageExtension: imageExtension) {
                avatar.image = image
                avatar.layer.cornerRadius = 8
                setNeedsUpdateConfiguration()
            } else {
                if let url = character.getUrlAvatar(size: .small) {
                    getImageNetwork(url: url) { [weak self] in
                        self?.avatar.image = $0
                        self?.avatar.layer.cornerRadius = 8
                        self?.setNeedsUpdateConfiguration()
                        saveImageCache(image: $0, imageName: imageName, imageExtension: imageExtension)
                    }
                }
            }
        }
    }

}
