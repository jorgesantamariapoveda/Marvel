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
