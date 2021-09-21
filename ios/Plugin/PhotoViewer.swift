import Foundation
import Capacitor
import UIKit

enum PhotoViewerError: Error {
    case failed(message: String)
}
@objc public class PhotoViewer: NSObject {
    var collectionViewController: CollectionViewController?

    // MARK: viewController

    @objc var viewController: CollectionViewController? {
        return collectionViewController
    }
    var sliderVC: SliderViewController?

    @objc var sliderController: SliderViewController? {
        return sliderVC
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
            sliderVC = SliderViewController()
            sliderVC?.modalPresentationStyle = .overFullScreen
            sliderVC?.position = IndexPath(row: 0, section: 0)
            sliderVC?.imageList = imageList
            var mOptions = options
            if mOptions.keys.contains("movieoptions") {
                mOptions.removeValue(forKey: "movieoptions")
            }
            sliderVC?.options = mOptions
            return true
        }
    }
}
