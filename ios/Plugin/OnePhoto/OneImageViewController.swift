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
    private var _backgroundColor: String = "black"
    private var _backColor: BackgroundColor = BackgroundColor()
    private var _colorRange: [String] = ["white", "ivory", "lightgrey"]
    private var _btColor: UIColor = UIColor.white

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
            if self._options.keys.contains("backgroundcolor") {
                if let backgroundColor = self._options["backgroundcolor"]
                    as? String {
                    self._backgroundColor = backgroundColor
                    if _colorRange.contains(_backgroundColor) {
                        _btColor = UIColor.black
                    }
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
    lazy var mClose: UIBarButtonItem = {
        let bClose = UIBarButtonItem()
        let image: UIImage?
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        image = UIImage(systemName: "multiply",
                        withConfiguration: configuration)
        bClose.image = image?.withTintColor(_btColor, renderingMode: .alwaysOriginal)
        bClose.tintColor = _btColor
        bClose.action = #selector(closeButtonTapped)
        return bClose
    }()
    lazy var mShare: UIBarButtonItem = {
        let bShare = UIBarButtonItem()
        let image: UIImage?
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        image = UIImage(systemName: "square.and.arrow.up",
                        withConfiguration: configuration)
        bShare.image = image?.withTintColor(_btColor, renderingMode: .alwaysOriginal)
        bShare.tintColor = _btColor
        bShare.action = #selector(shareButtonTapped)
        return bShare

    }()

    func addSubviewsToParentView(size: CGSize) {
        view.addSubview(mScrollView)
        mScrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        self.mScrollView.maximumZoomScale = self._maxZoomScale
        self.mScrollView.delegate = self

        if url.prefix(4) == "http" || url.contains("base64") {
            let imgPlaceHolder: UIImage?
            imgPlaceHolder = UIImage(systemName: "livephoto.slash")
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
        }

        if url.prefix(38) ==
            "file:///var/mobile/Media/DCIM/100APPLE" ||
            url.prefix(38) ==
            "capacitor://localhost/_capacitor_file_" {
            let image: UIImage = UIImage()
            self.mImageView.image = image.getImage(path: url,
                                                   placeHolder: "livephoto.slash")
            self.mScrollView.imageView = self.mImageView
        }

        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = mClose
        if self._isShare {
            navigationItem.leftBarButtonItem = mShare
        }
        mNavBar.setItems([navigationItem], animated: false)
        mNavBar.frame = CGRect(x: 0, y: 35,
                               width: size.width, height: 64)
        view.addSubview(mNavBar)
        setupGestureRecognizers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = _backColor
            .setBackColor(color: _backgroundColor)

        addSubviewsToParentView(size: CGSize(width: view.frame.width, height: view.frame.height))
    }

    // MARK: - viewDidDisappear

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        destroyAllGestures()
    }

    // MARK: - swipeAction

    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        let vId: [String: Any] =
            ["result": true,
             "imageIndex": startFrom
            ]
        NotificationCenter.default.post(name: .photoviewerExit,
                                        object: nil,
                                        userInfo: vId)
        //        self.dismissWithTransition()
        //        self.dismiss(animated: true, completion: nil)
        if swipe.direction == .up {
            // Slide-up gesture
            dismissWithTransition(swipeDirection: "up")
        } else if swipe.direction == .down {
            // Slide-down gesture
            dismissWithTransition(swipeDirection: "down")
        }
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
        self.dismissWithTransition(swipeDirection: "down")
        //        self.dismiss(animated: true, completion: nil)
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        mImageView.removeFromSuperview()
        mScrollView.removeFromSuperview()
        mNavBar.removeFromSuperview()

        addSubviewsToParentView(size: size)
    }

    // MARK: - setupGestureRecognizers

    private func setupGestureRecognizers() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
    }

    // MARK: - destroyAllGestures

    func destroyAllGestures() {
        view.gestureRecognizers?.removeAll()
    }
}
