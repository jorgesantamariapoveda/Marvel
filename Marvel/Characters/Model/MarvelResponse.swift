//
//  MarvelResponse.swift
//  Marvel
//
//  Created by Jorge on 06/03/2021.
//

import UIKit

// MARK: - Marvel Response

struct MarvelResponse: Decodable {
    let code: Int?
    let status: String?
    let data: DataClassResponse?
}

struct DataClassResponse: Decodable {
    let results: [CharacterResponse]?
}

struct CharacterResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: ThumbnailResponse?
    let comics: ComicsResponse?
    let series: ComicsResponse?
    let stories: StoriesResponse?
    let events: ComicsResponse?
}

struct ComicsResponse: Decodable {
    let available: Int?
}

struct StoriesResponse: Decodable {
    let available: Int?
}

struct ThumbnailResponse: Decodable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - Marvel Network

let kUrlBaseCharacters = "https://gateway.marvel.com/v1/public/characters"
let kTs = "1"
let kApikey = "52a2e3ff2df40e52385ab0c03ea649d9"
let kHash = "176766d3be9470eb2162da8287e0a877"

private func queryItemsMarvel() -> [URLQueryItem] {
    return [
        URLQueryItem(name: "ts", value: kTs),
        URLQueryItem(name: "apikey", value: kApikey),
        URLQueryItem(name: "hash", value: kHash)
    ]
}

func getCharactersNetwork(completion: @escaping (Result<[CharacterResponse], Error>) -> Void) {
    guard var urlComponents = URLComponents(string: kUrlBaseCharacters) else { return }
    urlComponents.queryItems = queryItemsMarvel()

    guard let url = urlComponents.url else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared
        .dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
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
        }
        .resume()
}

func getCharacterNetwork(id: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
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

func getImageNetwork(url: URL, completion: @escaping (UIImage) -> Void) {
    URLSession.shared
        .dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                return
            }
            if response.statusCode == 200 {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
        .resume()
}


