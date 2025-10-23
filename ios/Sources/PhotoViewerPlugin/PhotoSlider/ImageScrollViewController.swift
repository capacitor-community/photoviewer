//
//  ImageScrollViewController.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 05/03/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import UIKit

import SDWebImage

protocol ImageScrollViewControllerDelegate: AnyObject {
    func didOneTap()
    func didTwoTaps(point: CGPoint)
}

class ImageScrollViewController: UIViewController {
    weak var delegate: ImageScrollViewControllerDelegate?

    private var _url: String = ""
    private var _backgroundColor: UIColor = .black
    private var _maxZoomScale: CGFloat = 3.0
    private var _curZoomScale: CGFloat = 3.0
    private var _zoomIn: Bool = false
    private var _zoomInPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var _hasOneTap: Bool = false

    var dismissCompletion: (() -> Void)?

    // MARK: - Set-up options

    var url: String {
        get {
            return self._url
        }
        set {
            self._url = newValue
        }
    }
    var backgroundColor: UIColor {
        get {
            return self._backgroundColor
        }
        set {
            self._backgroundColor = newValue
        }

    }
    var maxZoomScale: CGFloat {
        get {
            return self._maxZoomScale
        }
        set {
            self._maxZoomScale = newValue
            self._curZoomScale = newValue
        }
    }
    var zoomIn: Bool {
        get {
            return self._zoomIn
        }
        set {
            self._zoomIn = newValue

        }
    }
    var zoomInPoint: CGPoint {
        get {
            return self._zoomInPoint
        }
        set {
            self._zoomInPoint = newValue

        }
    }
    var tapCell: Bool {
        get {
            return self._hasOneTap
        }
        set {
            self._hasOneTap = newValue

        }
    }
    // MARK: - Set-up Views

    lazy var mScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = self._backgroundColor
        return scrollView
    }()
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = self._backgroundColor
        return imageView
    }()

    // MARK: - loadView

    override func loadView() {
        view = UIView()
        let screenSize: CGRect = UIScreen.main.bounds
        view.frame = screenSize
        view.sizeToFit()
        view.clipsToBounds = true

    }

    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mScrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(mScrollView)
        mScrollView.addSubview(mImageView)
        if url.prefix(4) == "http" || url.contains("base64") {
            mImageView.sd_setImage(with: URL(string: url),
                                   placeholderImage: nil)
        }
        if url.prefix(38) ==
            "file:///var/mobile/Media/DCIM/100APPLE" ||
            url.prefix(38) ==
            "capacitor://localhost/_capacitor_file_" {
            let image: UIImage = UIImage()
            self.mImageView.image = image.getImage(path: url,
                                                   placeHolder: "livephoto.slash")
        }

        mImageView.translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizers()
    }

    // MARK: - viewWillLayoutSubviews

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateScrollView()
    }

    // MARK: - updateScrollView

    private func updateScrollView() {
        mImageView.frame = view.bounds
        mScrollView.frame = view.bounds
        mScrollView.contentSize = mImageView.bounds.size

        calculateMaximumZoomScale(mScrollView.bounds.size)
        if self._zoomIn {
            zoomInOrOut(at: self._zoomInPoint)
        }

    }

    // MARK: Add Gesture Recognizers

    func addGestureRecognizers() {
        let singleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        mScrollView.addGestureRecognizer(singleTapGesture)

        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        mScrollView.addGestureRecognizer(doubleTapRecognizer)

        singleTapGesture.require(toFail: doubleTapRecognizer)

        let pinchRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handlePinch(_:)))
        pinchRecognizer.numberOfTapsRequired = 1
        pinchRecognizer.numberOfTouchesRequired = 2
        mScrollView.addGestureRecognizer(pinchRecognizer)
    }

    @objc func handlePinch(_ recognizer: UITapGestureRecognizer) {
        var newZoomScale = mScrollView.zoomScale / 1.5
        newZoomScale = max(newZoomScale, mScrollView.minimumZoomScale)
        mScrollView.setZoomScale(newZoomScale, animated: true)
    }

    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: false, completion: dismissCompletion)
        if let mDelegate = delegate {
            mDelegate.didOneTap()
        } else {
            print("No delegate for this ImageScrollViewController")
        }
    }

    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: mImageView)
        if self._hasOneTap {
            zoomInOrOut(at: pointInView)
        } else {
            if mScrollView.zoomScale !=
                mScrollView.minimumZoomScale {
                mScrollView.zoomScale = mScrollView.minimumZoomScale
                dismiss(animated: false, completion: dismissCompletion)
                if let mDelegate = delegate {
                    mDelegate.didOneTap()
                } else {
                    print("No delegate for this ImageScrollViewController")
                }
            } else {
                if let mDelegate = delegate {
                    mDelegate.didTwoTaps(point: pointInView )
                } else {
                    print("No delegate for this ImageScrollViewController")
                }
            }
        }
    }
}

// MARK: Zoom Extension

extension ImageScrollViewController: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mImageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let yOffset = max(0, (view.frame.height - scrollView.contentSize.height) / 2)
        let xOffset = max(0, (view.frame.width - scrollView.contentSize.width) / 2)
        let point: CGPoint = CGPoint(x: 0 + xOffset, y: 0 + yOffset)
        mImageView.frame = CGRect(origin: point, size: scrollView.contentSize)
    }
}

// MARK: Adjusting the dimensions

extension ImageScrollViewController {

    func calculateMaximumZoomScale(_ size: CGSize) {
        if let img = mImageView.image {
            _curZoomScale = max(_curZoomScale, min( maxZoomScale, max(
                img.size.width  / size.width,
                img.size.height / size.height
            )))
        }
        mScrollView.maximumZoomScale = _curZoomScale * 1.1

    }
    func zoomInOrOut(at point: CGPoint) {

        let newZoomScale = mScrollView.zoomScale ==
            mScrollView.minimumZoomScale
            ? _curZoomScale : mScrollView.minimumZoomScale
        let size = mScrollView.bounds.size
        let newW = size.width / newZoomScale
        let newH = size.height / newZoomScale
        let newX = point.x - (newW * 0.5)
        let newY = point.y - (newH * 0.5)
        let rect = CGRect(x: newX, y: newY, width: newW, height: newH)
        mScrollView.zoom(to: rect, animated: true)

    }
}
