//
//  CharacterModel.swift
//  Marvel
//
//  Created by Jorge on 08/03/2021.
//

import Foundation

struct CharacterModel {

    let id: Int
    let name: String
    let description: String
    let numComics: Int
    let numSeries: Int
    let numStories: Int
    let pathAvatar: String
    let extensionAvatar: String

    // MARK: - Public functions

    func getUrlAvatar(size: ImageVariants = .small) -> URL? {
        let path = pathAvatar.replacingOccurrences(of: "http", with: "https")
        if let url = URL(string: "\(path)\(size.rawValue).\(extensionAvatar)") {
            return url
        }
        return nil
    }
}

