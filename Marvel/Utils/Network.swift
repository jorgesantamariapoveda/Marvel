//
//  Network.swift
//  Marvel
//
//  Created by Jorge on 09/03/2021.
//

import UIKit

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
