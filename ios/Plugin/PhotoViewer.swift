import Foundation
import Capacitor
import UIKit

enum PhotoViewerError: Error {
    case failed(message: String)
}
@objc public class PhotoViewer: NSObject {
    var collectionViewController: CollectionViewController?
    var oneImageViewController: OneImageViewController?

    // MARK: collectionController

    @objc var collectionController: CollectionViewController? {
        return collectionViewController
    }
    // MARK: oneImageController

    @objc var oneImageController: OneImageViewController? {
        return oneImageViewController
    }
    // MARK: echo

    @objc public func echo(_ value: String) -> String {
        return value
    }

    // MARK: show

    @objc public func show(_ imageList: [[String: String]],
                           options: [String: Any]) -> Bool {
        if imageList.count > 1 {
            collectionViewController = CollectionViewController()
            collectionViewController?.imageList = imageList
            collectionViewController?.options = options
            return true
        } else {
            oneImageViewController = OneImageViewController()
            if let imageUrl = imageList[0]["url"] {
                oneImageViewController?.url = imageUrl
                oneImageViewController?.options = options
                return true
            }
            return false
        }
    }
}
