//
//  CharactersModel.swift
//  Marvel
//
//  Created by Jorge on 08/03/2021.
//

import Foundation

struct CharactersModel {

    private var characters: [CharacterModel]
    var count: Int {
        characters.count
    }

    // MARK: - Public functions

    init (charactersResponse: [CharacterResponse]) {
        characters = charactersResponse.map { CharacterModel(characterResponse: $0) }
    }

    func getIdCharacter(index: Int) -> Int? {
        index < characters.count ? characters[index].getId() : nil
    }

    func getNameCharacter(index: Int) -> String {
        index < characters.count ? characters[index].getName() : ""
    }

    func getUrlAvatar(index: Int) -> URL? {
        index < characters.count ? characters[index].getUrlAvatar() : nil
    }

}
