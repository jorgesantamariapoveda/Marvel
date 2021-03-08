//
//  MarvelModel.swift
//  Marvel
//
//  Created by Jorge on 06/03/2021.
//

import UIKit

enum MarvelError: Error {
    case connectionError(Error)
    case statusCode(Int)
    case decoding
    case emptyData
}

enum ImageVariants: String {
    case small = "/portrait_small"
    case big = "/landscape_amazing"
}

struct MarvelModel {

    private var characters = [CharacterResponse]()
    private var selectedCharacter: CharacterResponse?

    private func queryItemsMarvel() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "ts", value: kTs),
            URLQueryItem(name: "apikey", value: kApikey),
            URLQueryItem(name: "hash", value: kHash)
        ]
    }

    func getImageMarvelNetwork(id: Int, size: ImageVariants, completion: @escaping (UIImage) -> Void) {
        if let character = characterById(id) {
            if let thumbnail = character.thumbnail,
               let path = thumbnail.path,
               let thumbnailExtension = thumbnail.thumbnailExtension {

                let newPath = path.replacingOccurrences(of: "http", with: "https")
                guard let url = URL(string: "\(newPath)\(size.rawValue).\(thumbnailExtension)") else {
                    return
                }

                getImageNetwork(url: url, completion: completion)
            }
        }
    }

}

// MARK: - Characters

extension MarvelModel {

    // MARK: - Public functions

    func numCharacters() -> Int {
        characters.count
    }

    func idCharacter(index: Int) -> Int? {
        if index < characters.count {
            return characters[index].id
        }
        return nil
    }

    func nameCharacterByIndex(_ index: Int) -> String {
        if index < characters.count {
            return characters[index].name ?? ""
        }
        return ""
    }

    private func characterById(_ id: Int) -> CharacterResponse? {
        if let character = characters.first(where: { $0.id == id }) {
            return character
        }
        return nil
    }

    mutating func setCharacters(_ charactersModel: [CharacterResponse]) {
        characters = charactersModel
    }

//    func charactersNetwork(completion: @escaping (Result<[CharacterResponse], Error>) -> Void) {
//        guard var urlComponents = URLComponents(string: kUrlBaseCharacters) else { return }
//        urlComponents.queryItems = queryItemsMarvel()
//
//        guard let url = urlComponents.url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data,
//                  let response = response as? HTTPURLResponse,
//                  error == nil else {
//                if let error = error {
//                    completion(.failure(MarvelError.connectionError(error)))
//                }
//                return
//            }
//
//            if response.statusCode == 200 {
//                do {
//                    let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
//                    if let charactersResponse = marvelResponse.data?.results {
//                        completion(.success(charactersResponse))
//                    } else {
//                        completion(.failure(MarvelError.emptyData))
//                    }
//                } catch {
//                    completion(.failure(MarvelError.decoding))
//                }
//            } else {
//                completion(.failure(MarvelError.statusCode(response.statusCode)))
//            }
//        }.resume()
//    }


}

// MARK: - Selected Character

extension MarvelModel {

    // MARK: - Queries

    mutating func setSelectedCharacter(_ characterModel: CharacterResponse) {
        selectedCharacter = characterModel
    }

    func getNumComics() -> String {
        if let available = selectedCharacter?.comics?.available {
            return "\(available)"
        }
        return ""
    }

    func getNumSeries() -> String {
        if let available = selectedCharacter?.series?.available {
            return "\(available)"
        }
        return ""
    }

    func getNumStories() -> String {
        if let available = selectedCharacter?.stories?.available {
            return "\(available)"
        }
        return ""
    }

    // MARK: - Network

//    func characterNetwork(id: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
//        guard var urlComponents = URLComponents(string: "\(kUrlBaseCharacters)/\(id)") else { return }
//        urlComponents.queryItems = queryItemsMarvel()
//
//        guard let url = urlComponents.url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data,
//                  let response = response as? HTTPURLResponse,
//                  error == nil else {
//                if let error = error {
//                    completion(.failure(MarvelError.connectionError(error)))
//                }
//                return
//            }
//
//            if response.statusCode == 200 {
//                do {
//                    let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
//                    if let characterResponse = marvelResponse.data?.results?.first {
//                        completion(.success(characterResponse))
//                    } else {
//                        completion(.failure(MarvelError.emptyData))
//                    }
//                } catch {
//                    completion(.failure(MarvelError.decoding))
//                }
//            } else {
//                completion(.failure(MarvelError.statusCode(response.statusCode)))
//            }
//        }.resume()
//    }

    func imageNetworkSelectedCharacter(id: Int, completion: @escaping (UIImage) -> Void) {
        getImageMarvelNetwork(id: selectedCharacter?.id ?? 0, size: .big, completion: completion)
    }

}

struct CharacterModel {
    let id: Int

}
