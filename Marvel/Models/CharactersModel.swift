//
//  CharactersModel.swift
//  Marvel
//
//  Created by Jorge on 08/03/2021.
//

import Foundation

struct CharactersModel {

    var characters: [CharacterModel]
    var count: Int {
        characters.count
    }

    // MARK: - Public functions

    init (charactersResponse: [CharacterResponse]) {
        characters = charactersResponse.map {
            return CharacterModel(
                id: $0.id ?? 0,
                name: $0.name ?? "",
                description: $0.description ?? "",
                numComics: $0.comics?.available ?? 0,
                numSeries: $0.series?.available ?? 0,
                numStories: $0.stories?.available ?? 0,
                pathAvatar: $0.thumbnail?.path ?? "",
                extensionAvatar: $0.thumbnail?.thumbnailExtension ?? "")
        }
    }

    func getNameCharacter(index: Int) -> String {
        if index < characters.count {
            return characters[index].name
        }
        return ""
    }

    func getUrlAvatar(index: Int) -> URL? {
        if index < characters.count {
            return characters[index].getUrlAvatar()
        }
        return nil
    }

}
