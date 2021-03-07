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

}
