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

    func getCharacter(index: Int) -> CharacterModel? {
        index < characters.count ? characters[index] : nil
    }

}
