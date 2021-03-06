//
//  SliderViewController.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 25/02/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//
import UIKit

import SDWebImage

class SliderViewController: UIViewController {

    private var _numCells: CGFloat = 3
    private var _numImages: Int = 0
    private var _imageList: [[String: String]] = []
    private var _options: [String: Any] = [:]
    private var _position: IndexPath = [0, 0]
    private var _selectedPosition: IndexPath?
    private var _isShare: Bool = true
    private var _toast: Toast = Toast()
    private var _imageViewer: ImageScrollViewController?
    private var _maxZoomScale: Double = 3
    private var _compressionQuality: Double = 0.8

    // MARK: - Set-up position

    var position: IndexPath {
        get {
            return self._position
        }
        set {
            self._position = newValue
        }
    }

    // MARK: - Set-up imageList

    var imageList: [[String: String]] {
        get {
            return self._imageList
        }
        set {
            self._imageList = newValue
            self._numImages = self._imageList.count
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
                    self._maxZoomScale = maxZoomScale
                }
            }
            if self._options.keys.contains("compressionquality") {
                if let compressionQuality = self._options[""] as? Double {
                    self._compressionQuality = compressionQuality
                }
            }
        }
    }
    lazy var navBar: UINavigationBar = { () -> UINavigationBar in

        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: view.frame.size.width, height: 64))
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = mClose
        if self._isShare {
            navigationItem.leftBarButtonItem = mShare
        }
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()
    lazy var mClose: UIBarButtonItem = {
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
            bClose.setTitleTextAttributes([NSAttributedString.Key
                                            .foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: font], for: .normal)
        }
        bClose.tintColor = .white
        bClose.action = #selector(closeButtonTapped)
        return bClose
    }()
    lazy var  mShare: UIBarButtonItem = {
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
            bShare.setTitleTextAttributes([NSAttributedString.Key
                                            .foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: font], for: .normal)
        }
        bShare.tintColor = .white
        bShare.action = #selector(shareButtonTapped)
        return bShare

    }()

    lazy var layout: UICollectionViewFlowLayout = { () -> UICollectionViewFlowLayout in
        let mLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        mLayout.minimumLineSpacing = 0
        mLayout.minimumInteritemSpacing = 0
        return mLayout
    }()
    lazy var collectionView: UICollectionView = {
        let mColView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        mColView.register(SliderViewCell.self, forCellWithReuseIdentifier: SliderViewCell.identifier)
        mColView.dataSource = self
        mColView.delegate = self
        mColView.isPagingEnabled = true
        return mColView
    }()

    override func loadView() {
        view = UIView()
        let screenSize: CGRect = UIScreen.main.bounds
        view.frame.size.width = screenSize.width
        view.frame.size.height = screenSize.height
        view.sizeToFit()
        view.backgroundColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(collectionView)
        view.addSubview(navBar)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCollectionView()
        updateLayout(view.frame.size)
        self.navBar.frame = CGRect(x: 0, y: 35,
                                   width: view.frame.size.width, height: 64)
    }
    private func updateCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
            .isActive = true
        collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
            .isActive = true
        collectionView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        collectionView.isPagingEnabled = true
        DispatchQueue.main.async {
            var mPosition = self.position
            if let selPos = self._selectedPosition {
                mPosition = selPos
            }
            self.collectionView.scrollToItem(at: mPosition,
                                             at: .centeredHorizontally,
                                             animated: false)
        }

    }
    private func updateLayout(_ size: CGSize) {
        let cellWidth = size.width
        let cellHeight = size.height
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth,
                                 height: cellHeight)
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionView()
        updateLayout(size)
        self.navBar.frame = CGRect(x: 0, y: 35,
                                   width: view.frame.size.width, height: 64)

    }
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func shareButtonTapped() {
        var mPosition = self.position
        if let selPos = self._selectedPosition {
            mPosition = selPos
        }
        if let imageUrl: String = self.imageList[mPosition.row]["url"] {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
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
        } else {
            print("No url available")
        }
    }

}
extension SliderViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return _numImages
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: SliderViewCell
                                    .identifier, for: indexPath) as? SliderViewCell

        if let mCell = cell {
            mCell.options = self.options
            if let imageUrl: String = self.imageList[indexPath.row]["url"] {
                if let title: String = self.imageList[indexPath.row]["title"] {
                    mCell.configure(imageUrl: imageUrl, title: title)
                    mCell.delegate = self
                    return mCell
                } else {
                    print("Error: image title not found")
                    return UICollectionViewCell()
                }
            } else {
                print("Error: image url not found")
                return UICollectionViewCell()
            }
        } else {
            print("Error: cell not found")
            return UICollectionViewCell()
        }
    }
}
extension SliderViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            _selectedPosition = indexPath
        }
    }
}

extension SliderViewController: SliderViewCellDelegate {
    func didShowButtons() {
        var mPosition = self.position
        if let selPos = self._selectedPosition {
            mPosition = selPos
        }
        if navBar.alpha == 1.0 {
            if let imageUrl: String = self.imageList[mPosition.row]["url"] {
                self._imageViewer = ImageScrollViewController()
                self._imageViewer?.delegate = self
                self.collectionView.alpha = 0
                self._imageViewer?.dismissCompletion = {
                    UIView.animate(withDuration: 0.3) {
                        self.collectionView.alpha = 1.0
                        self.navBar.alpha = 1.0
                    }
                }

                self._imageViewer?.url = imageUrl
                self._imageViewer?.maxZoomScale = CGFloat(_maxZoomScale)
                if let imgViewer = self._imageViewer {
                    imgViewer.modalPresentationStyle = .overFullScreen

                    self.present(imgViewer, animated: false)
                } else {
                    print("no self._imageViewer")
                }
            } else {
                print("No imgage available")
            }

            UIView.animate(withDuration: 0.3) {
                self.navBar.alpha = 0.0
            }
        }
    }
}
extension SliderViewController: ImageScrollViewControllerDelegate {
    func didOneTap() {
        didShowButtons()
    }
}
extension UICollectionViewFlowLayout {
    override open func shouldInvalidateLayout(forBoundsChange: CGRect) -> Bool {
        return true
    }
}
