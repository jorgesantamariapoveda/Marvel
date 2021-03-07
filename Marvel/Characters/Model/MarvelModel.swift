//
//  MarvelModel.swift
//  Marvel
//
//  Created by Jorge on 06/03/2021.
//

import Foundation
import UIKit

enum MarvelError: Error {
    case connectionError(Error)
    case statusCode(Int)
    case decoding
    case emptyData
}

enum ImageVariants: String {
    case small = "/portrait_small"
    case big = "/landscape_incredible"
}

struct MarvelModel {

    private var characters = [CharacterResponse]()

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

    func nameCharacterByIndex(_ index: Int) -> String? {
        if index < characters.count {
            return characters[index].name
        }
        return nil
    }

    func nameCharacterById(_ id: Int) -> String? {
        if let character = characterById(id) {
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

    mutating func updateCharactersModel(_ charactersModel: [CharacterResponse]) {
        characters = charactersModel
    }

    func charactersNetwork(completion: @escaping (Result<[CharacterResponse], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: kUrlBaseCharacters) else { return }
        urlComponents.queryItems = queryItemsMarvel()

        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                if let error = error {
                    completion(.failure(MarvelError.connectionError(error)))
                }
                return
            }

            if response.statusCode == 200 {
                do {
                    let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
                    if let charactersResponse = marvelResponse.data?.results {
                        completion(.success(charactersResponse))
                    } else {
                        completion(.failure(MarvelError.emptyData))
                    }
                } catch {
                    completion(.failure(MarvelError.decoding))
                }
            } else {
                completion(.failure(MarvelError.statusCode(response.statusCode)))
            }
        }.resume()
    }

    func characterNetwork(id: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "\(kUrlBaseCharacters)/\(id)") else { return }
        urlComponents.queryItems = queryItemsMarvel()

        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                if let error = error {
                    completion(.failure(MarvelError.connectionError(error)))
                }
                return
            }

            if response.statusCode == 200 {
                do {
                    let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
                    if let characterResponse = marvelResponse.data?.results?.first {
                        completion(.success(characterResponse))
                    } else {
                        completion(.failure(MarvelError.emptyData))
                    }
                } catch {
                    completion(.failure(MarvelError.decoding))
                }
            } else {
                completion(.failure(MarvelError.statusCode(response.statusCode)))
            }
        }.resume()
    }

    func imageNetwork(id: Int, size: ImageVariants, completion: @escaping (UIImage) -> Void) {
        if let character = characterById(id) {
            if let thumbnail = character.thumbnail,
               let path = thumbnail.path,
               let thumbnailExtension = thumbnail.thumbnailExtension {

                let newPath = path.replacingOccurrences(of: "http", with: "https")
                guard let url = URL(string: "\(newPath)\(size.rawValue).\(thumbnailExtension)") else {
                    return
                }

                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data,
                          let response = response as? HTTPURLResponse,
                          error == nil else {
                        return
                    }

                    if response.statusCode == 200 {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }
                    }
                }.resume()
            }
        }
    }

    // MARK: - private functions

    private func characterById(_ id: Int) -> CharacterResponse? {
        if let character = characters.first(where: { $0.id == id }) {
            return character
        }
        return nil
    }

    private func queryItemsMarvel() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "ts", value: kTs),
            URLQueryItem(name: "apikey", value: kApikey),
            URLQueryItem(name: "hash", value: kHash)
        ]
    }

}

