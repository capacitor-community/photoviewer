import Foundation
import Capacitor

enum PhotoViewerError: Error {
    case failed(message: String)
}
@objc public class PhotoViewer: NSObject {
    var collectionViewController: CollectionViewController?

    @objc var viewController: CollectionViewController? {
        return collectionViewController
    }

    @objc public func echo(_ value: String) -> String {
        return value
    }
    @objc public func show(_ imageList: [[String: String]],
                           options: [String: Any]) -> Bool {

        collectionViewController = CollectionViewController()
        collectionViewController?.imageList = imageList
        collectionViewController?.options = options
        return true
    }
}
