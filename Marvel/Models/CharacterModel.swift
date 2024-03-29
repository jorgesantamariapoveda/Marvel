//
//  CharacterModel.swift
//  Marvel
//
//  Created by Jorge on 08/03/2021.
//

import Foundation

struct CharacterModel {

    private let id: Int?
    private let name: String?
    private let description: String?
    private let numComics: Int?
    private let numSeries: Int?
    private let numStories: Int?
    private let pathAvatar: String?
    private let extensionAvatar: ImageExtension?

    // MARK: - Public functions

    init (characterResponse: CharacterResponse) {
        self.id = characterResponse.id
        self.name = characterResponse.name
        self.description = characterResponse.description
        self.numComics = characterResponse.comics?.available
        self.numSeries = characterResponse.series?.available
        self.numStories = characterResponse.stories?.available
        self.pathAvatar = characterResponse.thumbnail?.path
        self.extensionAvatar = characterResponse.thumbnail?.thumbnailExtension
    }

    func getId() -> Int? {
        id
    }

    func getName() -> String {
        name ?? ""
    }

    func getDescription() -> String {
        if let description = description {
            if description.isEmpty {
                return IdSinDescripcion
            } else {
                return description
            }
        }
        return IdSinDescripcion
    }

    func getNumComics() -> String {
        if let numComics = numComics {
            return "\(numComics)"
        }
        return ""
    }

    func getNumSeries() -> String {
        if let numSeries = numSeries {
            return "\(numSeries)"
        }
        return ""
    }

    func getNumStories() -> String {
        if let numStories = numStories {
            return "\(numStories)"
        }
        return ""
    }

    func getUrlAvatar(size: ImageVariants) -> URL? {
        if let pathAvatar = pathAvatar,
           let extensionAvatar = extensionAvatar {
            let path = pathAvatar.replacingOccurrences(of: "http", with: "https")
            if let url = URL(string: "\(path)\(size.rawValue).\(extensionAvatar.rawValue)") {
                return url
            }
            return nil
        } else {
            return nil
        }
    }

    func getImageInfo() -> (imageName: String?, imageExtension: ImageExtension?) {
        guard let path = pathAvatar else {
            return (nil, nil)
        }
        let imageName = path.components(separatedBy: "/").last

        return (imageName, extensionAvatar)
    }

}

