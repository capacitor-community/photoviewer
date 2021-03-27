import Foundation
import Capacitor

enum PhotoViewerError: Error {
    case failed(message: String)
}
@objc public class PhotoViewer: NSObject {
    var collectionViewController: CollectionViewController?

    // MARK: viewController

    @objc var viewController: CollectionViewController? {
        return collectionViewController
    }

    // MARK: echo

    @objc public func echo(_ value: String) -> String {
        return value
    }

    // MARK: show

    @objc public func show(_ imageList: [[String: String]],
                           options: [String: Any]) -> Bool {

        collectionViewController = CollectionViewController()
        collectionViewController?.imageList = imageList
        collectionViewController?.options = options
        return true
    }
}
