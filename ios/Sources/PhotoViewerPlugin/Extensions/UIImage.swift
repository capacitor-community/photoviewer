//
//  UIImage.swift
//  CapacitorCommunityPhotoviewer
//
//  Created by  Quéau Jean Pierre on 03/10/2022.
//

import UIKit

extension UIImage {

    func getImage(path: String, placeHolder: String?) -> UIImage? {
        let appPath: String = NSSearchPathForDirectoriesInDomains(.applicationDirectory,
                                                                  .userDomainMask,
                                                                  true)[0]
        let appId: String = getApplicationId(appPath: appPath)
        // get the appId from the appPath
        let pathArray = appPath.components(separatedBy: "Containers")
        let fPathArray: [String] = path.components(separatedBy: "mobile/")
        if fPathArray.count != 2 {
            let msg = "data for image url \(path) not loaded"
            let retImg = errorImage(message: msg, placeHolder: placeHolder)
            return retImg
        }
        var mPath = fPathArray[1]
        if fPathArray[1].contains("Application") {
            mPath = replaceAppId(appId: appId, path: fPathArray[1])
        }
        if let uPath = URL(string: pathArray[0]) {
            let fPath = (uPath.appendingPathComponent(
                            String(mPath))
            ).absoluteString
            let mUrl = URL(fileURLWithPath: fPath)
            var imageData: Data?
            do {
                imageData = try Data(contentsOf: mUrl)
            } catch {
                let msg = "\(error.localizedDescription)"
                let retImg = errorImage(message: msg, placeHolder: placeHolder)
                return retImg
            }

            guard let dataOfImage = imageData else {
                let msg = "Error: data for image url \(mUrl) not loaded"
                let retImg = errorImage(message: msg, placeHolder: placeHolder)
                return retImg

            }
            let retImg: UIImage? = .init(data: dataOfImage)
            return retImg
        }
        let msg = "Error: image url \(path) not supported"
        let retImg = errorImage(message: msg, placeHolder: placeHolder)
        return retImg
    }
    private func errorImage(message: String, placeHolder: String?) -> UIImage? {
        print("Error: \(message)")
        var retImg: UIImage?
        if let pHolder = placeHolder {
            retImg = .init(systemName: pHolder)
        } else {
            retImg = .init()
        }
        return retImg

    }
    private func getApplicationId(appPath: String) -> String {
        var retPath: String = ""
        let pathArray = appPath.components(separatedBy: "Applications")
        if let uPath = URL(string: pathArray[0]) {
            retPath = String(uPath.lastPathComponent)
        }

        return retPath
    }
    private func replaceAppId(appId: String, path: String) -> String {
        var retPath: String = ""
        let pathArray = path.components(separatedBy: "Application/")
        var appArray = pathArray[1].components(separatedBy: "/")
        appArray[0] = appId
        retPath = "\(pathArray[0])Application/\(appArray.joined(separator: "/"))"
        return retPath
    }
}
