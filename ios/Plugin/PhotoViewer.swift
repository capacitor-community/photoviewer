import Foundation
import Capacitor
import UIKit
import SDWebImage

enum PhotoViewerError: Error {
    case failed(message: String)
}
@objc public class PhotoViewer: NSObject {
    var collectionViewController: CollectionViewController?
    var oneImageViewController: OneImageViewController?
    var sliderViewController: SliderViewController?
    var stFrom: Int = 0
    private var config: PhotoViewerConfig

    init(config: PhotoViewerConfig) {
        self.config = config
        super.init()
    }

    // MARK: collectionController

    @objc var collectionController: CollectionViewController? {
        return collectionViewController
    }
    // MARK: oneImageController

    @objc var oneImageController: OneImageViewController? {
        return oneImageViewController
    }
    // MARK: oneImageController

    @objc var sliderController: SliderViewController? {
        return sliderViewController
    }

    // MARK: echo

    @objc public func echo(_ value: String) -> String {
        return value
    }

    // MARK: show

    @objc public func show(_ imageList: [[String: String]],
                           mode: String, startFrom: Int,
                           options: [String: Any]) -> Bool {
        stFrom = startFrom > imageList.count - 1 ? imageList.count - 1
            : startFrom

        // setup custom headers on SDWebImageDownloader
        let customHeaders = options["customHeaders"] as? [String: String] ?? [:]
        for (key, value) in customHeaders {
            SDWebImageDownloader.shared.setValue(value, forHTTPHeaderField: key)
            SDWebImageDownloader().setValue(value, forHTTPHeaderField: key)
        }

        if imageList.count > 1  && mode == "gallery" {
            collectionViewController = CollectionViewController()
            collectionViewController?.imageList = imageList
            collectionViewController?.options = options
            return true
        } else if mode == "one" {
            oneImageViewController = OneImageViewController()
            if let imageUrl = imageList[stFrom]["url"] {
                oneImageViewController?.url = imageUrl
                oneImageViewController?.startFrom = stFrom
                oneImageViewController?.options = options
                return true
            }
            return false
        } else if imageList.count > 1 && mode == "slider" {
            let position: IndexPath = [0, stFrom]
            sliderViewController = SliderViewController()
            sliderViewController?.imageList = imageList
            sliderViewController?.position = position
            sliderViewController?.mode = mode
            sliderViewController?.options = options
            return true
        } else {
            return false
        }
    }

    @objc public func saveImageFromHttpToInternal(_ call: CAPPluginCall, url: String,
                                                  fileName: String) throws {
        // get image location from the config
        guard let imageLocation = config.iosImageLocation else {
            let message = "You must have 'iosImageLocation' defined in " +
                "the capacitor.config.ts file"
            throw PhotoViewerError.failed(message: message)
        }
        guard let imageURL = URL(string: url) else {
            let message = "could not convert image url to URL"
            throw PhotoViewerError.failed(message: message)
        }

        UtilsImage.downloadAndSaveImage(imageURL: imageURL,
                                        imageName: fileName,
                                        imageLocation: imageLocation) { result in
            switch result {
            case .success(let imagePath):
                // convert the filepath into a Web View-friendly path.
                if let range = imagePath.path.range(of: "/Containers/", options: .backwards) {
                    let extractedPath = imagePath.path[range.upperBound...]
                    let resultPath = "capacitor://localhost/_capacitor_file_" +
                        "/var/mobile/Containers/" + String(extractedPath)
                    call.resolve(["webPath": resultPath])
                } else {
                    call.resolve(["message": "cannot create the Web View-friendly path"])
                }
            case .failure(let error):
                call.reject("Error: \(error)")
                return
            }
        }

    }
    @objc public func getInternalImagePaths() throws -> [String] {
        // get image location from the config
        guard let imageLocation = config.iosImageLocation else {
            let message = "You must have 'iosImageLocation' defined in " +
                "the capacitor.config.ts file"
            throw PhotoViewerError.failed(message: message)
        }
        do {
            let pathList = try UtilsImage.listOfImagePath(for: imageLocation)
            return pathList
        } catch let error {
            throw PhotoViewerError.failed(message: error.localizedDescription)
        }

    }
}
