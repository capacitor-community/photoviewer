//
//  UIImageView.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 27/09/2022.
//  Copyright © 2022 Max Lynch. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImageFromInternalUrl(url: String, imgPlaceHolder: UIImage?) {
        let appPath: String = NSSearchPathForDirectoriesInDomains(.applicationDirectory,
                                                                  .userDomainMask,
                                                                  true)[0]
        // get the appId from the appPath
        let pathArray = appPath.components(separatedBy: "Containers")
        let fPathArray = url.components(separatedBy: "mobile/")
        
        if let uPath = URL(string: pathArray[0]) {
            let fPath = (uPath.appendingPathComponent(
                String(fPathArray[1]))
            ).absoluteString
            let mUrl = URL(fileURLWithPath: fPath)
            var imageData : Data?
            do {
                imageData = try Data(contentsOf: mUrl)
            } catch {
                print(error.localizedDescription)
                self.image = imgPlaceHolder
                return
            }
            
            guard let dataOfImage = imageData else {
                print("Error: data for image url \(mUrl) not loaded")
                self.image = imgPlaceHolder
                return
            }
            guard let image = UIImage(data: dataOfImage) else {
                print("Error: image not loaded")
                self.image = imgPlaceHolder
                return
            }
            self.image = image
            return
        }
        self.image = imgPlaceHolder
        return
    }
}
