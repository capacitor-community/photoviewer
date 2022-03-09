//
//  OneImageViewController.swift
//  Capacitor
//
//  Created by  Quéau Jean Pierre on 30/09/2021.
//

import UIKit

import SDWebImage
import ISVImageScrollView

class OneImageViewController: UIViewController, UIScrollViewDelegate {
    private var _url: String = ""
    private var _maxZoomScale: CGFloat = 3.0
    private var _minZoomScale: CGFloat = 1.0
    private var _compressionQuality: Double = 0.8
    private var _options: [String: Any] = [:]
    private var _isShare: Bool = true
    private var _startFrom: Int = 0

    // MARK: - Set-up url

    var url: String {
        get {
            return self._url
        }
        set {
            self._url = newValue
        }
    }

    var startFrom: Int {
        get {
            return self._startFrom
        }
        set {
            self._startFrom = newValue
        }
    }

    // MARK: - Set-up options

    var options: [String: Any] {
        get {
            return self._options
        }
        set {
            self._options = newValue
            if self._options.keys.contains("share") {
                if let isShare = self._options["share"] as? Bool {
                    self._isShare = isShare
                }
            }
            if self._options.keys.contains("maxzoomscale") {
                if let maxZoomScale = self._options["maxzoomscale"] as? Double {
                    self._maxZoomScale = CGFloat(maxZoomScale)
                }
            }
            if self._options.keys.contains("compressionquality") {
                if let compressionQuality = self._options["compressionquality"]
                    as? Double {
                    self._compressionQuality = compressionQuality
                }
            }
        }
    }

    private let mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let mScrollView: ISVImageScrollView = {
        let scrollView = ISVImageScrollView()
        return scrollView
    }()
    private let mNavBar: UINavigationBar = { () -> UINavigationBar in

        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        return navigationBar
    }()
    private let mClose: UIBarButtonItem = {
        let bClose = UIBarButtonItem()
        let image: UIImage?
        if #available(iOS 13, *) {
            let configuration = UIImage.SymbolConfiguration(scale: .large)
            image = UIImage(systemName: "multiply",
                            withConfiguration: configuration)
            bClose.image = image
        } else {

            bClose.title = "Close"
            let fontSize: CGFloat = 18
            let font: UIFont = UIFont.boldSystemFont(ofSize: fontSize)
            bClose.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.white,
                 NSAttributedString.Key.font: font], for: .normal)
        }
        bClose.tintColor = .white
        bClose.action = #selector(closeButtonTapped)
        return bClose
    }()
    private let  mShare: UIBarButtonItem = {
        let bShare = UIBarButtonItem()
        let image: UIImage?
        if #available(iOS 13, *) {
            let configuration = UIImage.SymbolConfiguration(scale: .large)
            image = UIImage(systemName: "square.and.arrow.up",
                            withConfiguration: configuration)
            bShare.image = image
        } else {
            bShare.title = "Share"
            let fontSize: CGFloat = 18
            let font: UIFont = UIFont.boldSystemFont(ofSize: fontSize)
            bShare.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.white,
                 NSAttributedString.Key.font: font], for: .normal)
        }
        bShare.tintColor = .white
        bShare.action = #selector(shareButtonTapped)
        return bShare

    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black

        let imgPlaceHolder: UIImage?
        if #available(iOS 13, *) {
            imgPlaceHolder = UIImage(systemName: "livephoto.slash")
        } else {
            imgPlaceHolder = nil
        }
        view.addSubview(mScrollView)
        mScrollView.frame = view.frame
        self.mScrollView.maximumZoomScale = self._maxZoomScale
        self.mScrollView.delegate = self
        mImageView.sd_setImage(with: URL(string: url), placeholderImage: imgPlaceHolder, completed: {image, error, _, url in
            if let err = error {
                print("Error: \(err)")
                return
            }
            guard let imgUrl = url else {
                print("Error: image url not correct")
                return
            }
            guard let img = image else {
                print("Error: image url \(imgUrl) not loaded")
                return
            }
            self.mImageView.image = img
            self.mScrollView.imageView = self.mImageView

        })
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = mClose
        if self._isShare {
            navigationItem.leftBarButtonItem = mShare
        }
        mNavBar.setItems([navigationItem], animated: false)
        mNavBar.frame = CGRect(x: 0, y: 35,
                               width: view.frame.size.width, height: 64)

        view.addSubview(mNavBar)
    }

    // MARK: - closeButtonTapped

    @objc func closeButtonTapped() {
        let vId: [String: Any] =
            ["result": true,
             "imageIndex": startFrom
            ]
        NotificationCenter.default.post(name: .photoviewerExit,
                                        object: nil,
                                        userInfo: vId)

        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - shareButtonTapped

    @objc func shareButtonTapped() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: url),
                              placeholderImage: nil)
        if let image = imageView.image {
            if let data = image.jpegData(compressionQuality:
                                            CGFloat(_compressionQuality)) {
                let avc = UIActivityViewController(activityItems: [data],
                                                   applicationActivities: [])
                present(avc, animated: true)
            }
        } else {
            print("No imgage available")
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= self._minZoomScale {
            scrollView.zoomScale = self._minZoomScale
            /*
             UIView.animate(withDuration: 0.3) {
             self.mNavBar.alpha = 1.0
             }
             */
        } else if scrollView.zoomScale > self._maxZoomScale {
            scrollView.zoomScale = self._maxZoomScale
        } else {
            /*
             UIView.animate(withDuration: 0.3) {
             self.mNavBar.alpha = 0.0
             }
             */
        }
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale <= self._minZoomScale {
            scrollView.zoomScale = self._minZoomScale
        }
    }
}
