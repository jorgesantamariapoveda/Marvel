//
//  MarvelResponse.swift
//  Marvel
//
//  Created by Jorge on 06/03/2021.
//

import UIKit

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
    let thumbnailExtension: ImageExtension?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum ImageExtension: String, Decodable {
    case gif
    case jpg
}

