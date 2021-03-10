//
//  FileManager.swift
//  Marvel
//
//  Created by Jorge on 10/03/2021.
//

import UIKit

private func isImageExtensionSupported(imageExtension: ImageExtension) -> Bool {
    switch imageExtension {
    case .gif:
        return false
    case .jpg:
        return true
    }
}

private func convertUIImageToData(image: UIImage, imageExtension: ImageExtension) -> Data? {
    switch imageExtension {
    case .gif:
        return nil
    case .jpg:
        return image.jpegData(compressionQuality: 1)
    }
}

func saveImageCache(image: UIImage, imageName: String, imageExtension: ImageExtension) {
    if isImageExtensionSupported(imageExtension: imageExtension) {
        guard let documents = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        let fichero = documents.appendingPathComponent(imageName).appendingPathExtension(imageExtension.rawValue)
        DispatchQueue.global(qos: .background).async {
            do {
                if let data = convertUIImageToData(image: image, imageExtension: imageExtension) {
                    try data.write(to: fichero, options: [.atomicWrite, .completeFileProtection])
                } else {
                    print("Problem generating the data")
                }
            } catch {
                print("Error in saveImageCache \(error)")
            }
        }
    }
}

func loadImageCache(imageName: String, imageExtension: ImageExtension) -> UIImage? {
    if isImageExtensionSupported(imageExtension: imageExtension) {
        guard let documents = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fichero = documents.appendingPathComponent(imageName).appendingPathExtension(imageExtension.rawValue)
        if FileManager.default.fileExists(atPath: fichero.path) {
            do {
                let imageData = try Data(contentsOf: fichero)
                return UIImage(data: imageData)
            } catch {
                print("Error in loadImageCache \(error)")
            }
        }
    }
    return nil
}
