//
//  MarvelModel.swift
//  Marvel
//
//  Created by Jorge on 06/03/2021.
//

import Foundation

struct MarvelModel {

    private var characters = [CharacterResponse]()

    func numCharacters() -> Int {
        characters.count
    }

    func idCharacter(index: Int) -> Int? {
        if index < characters.count {
            return characters[index].id
        }
        return nil
    }

    func nameCharacterByIndex(_ index: Int) -> String? {
        if index < characters.count {
            return characters[index].name
        }
        return nil
    }

    func nameCharacterById(_ id: Int) -> String? {
        if let character = characters.first(where: { $0.id == id }) {
            return character.name
        }
        return nil
    }

    func descriptionCharacter(index: Int) -> String? {
        if index < characters.count {
            return characters[index].description
        }
        return nil
    }

}

