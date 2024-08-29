//
//  UtlisFile.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 22/09/2023.
//  Copyright © 2023 Max Lynch. All rights reserved.
//

import Foundation
import UIKit

enum UtilsImageError: Error {
    case directoryURLFailed(message: String)
    case listOfImagePathFailed(message: String)
}
class UtilsImage {
    class func getFileExtension(from url: String) -> String? {
        if let urlComponents = URLComponents(string: url) {
            if let path = urlComponents.url?.path {
                let pathExtension = (path as NSString).pathExtension
                if !pathExtension.isEmpty {
                    return pathExtension
                }
            }
        }
        return nil
    }
    class func directoryURL(for imageLocation: String) throws -> URL? {

        let folders = splitImageLocation(for: imageLocation)
        switch folders[0] {
        case "Library":
            if let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                let directory = libraryDirectory.appendingPathComponent(folders[1])
                return directory
            }
            return nil
        case "Documents":
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let directory = documentsDirectory.appendingPathComponent(folders[1])
                return directory
            }
            return nil
        default:
            let msg = "iosImageLocation must start with 'Library' or 'Documents'"
            throw UtilsImageError.directoryURLFailed(message: msg)
        }
    }
    class func splitImageLocation(for imageLocation: String) -> [String] {
        let components = imageLocation.components(separatedBy: "/")
        let joinedString = components[1..<components.count].joined(separator: "/")
        return [components[0], joinedString]
    }

    class func listOfImagePath(for imageLocation: String) throws -> [String] {
        do {
            var listPath: [String] = []
            guard let imageDirectoryURL = try UtilsImage.directoryURL(for: imageLocation)
            else {
                throw UtilsImageError.listOfImagePathFailed(message: "InvalidImageDirectory")
            }
            // Get the contents of the Library/Images directory
            let fileURLs = try FileManager.default
                .contentsOfDirectory(at: imageDirectoryURL,
                                     includingPropertiesForKeys: nil, options: [])

            // Define a list of valid image file extensions
            let validImageExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "tiff"]

            // Loop through the file URLs and print their paths or perform any other desired actions
            for fileURL in fileURLs {
                // Check if the file has a valid image extension
                if validImageExtensions
                    .contains(fileURL.pathExtension.lowercased()) {
                    if let range = fileURL.path.range(of: "/Containers/",
                                                      options: .backwards) {
                        let extractedPath = fileURL.path[range.upperBound...]
                        let resultPath = "capacitor://localhost/_capacitor_file_" +
                            "/var/mobile/Containers/" + String(extractedPath)

                        listPath.append(resultPath)
                    } else {
                        listPath.append(fileURL.path)
                    }
                }
            }
            return listPath
        } catch {
            let msg = "\(error)"
            throw UtilsImageError.listOfImagePathFailed(message: msg)
        }
    }

    class func downloadAndSaveImage(imageURL: URL, imageName: String, imageLocation: String,
                                    completion: @escaping (Result<URL, Error>)
                                        -> Void) {

        let urlSession = URLSession.shared

        let task = urlSession.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "InvalidImageData", code: 0, userInfo: nil)))
                return
            }

            // Get the Library directory URL
            do {
                guard let imageDirectory = try directoryURL(for: imageLocation)
                else {
                    completion(.failure(NSError(domain: "InvalidImageDirectory", code: 0, userInfo: nil)))
                    return
                }
                // Create the "Images" directory if it doesn't exist
                try FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true, attributes: nil)

                // Combine the directory and filename to create the full path
                let imagePath = imageDirectory
                    .appendingPathComponent(imageName + ".jpeg")

                // Save the image to the Library/Images folder

                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    try imageData.write(to: imagePath)
                    print("Image saved to: \(imagePath.path)")

                    completion(.success(imagePath))
                }

            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
