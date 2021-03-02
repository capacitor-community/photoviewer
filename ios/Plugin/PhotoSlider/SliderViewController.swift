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
        mColView.backgroundColor = .darkGray
        mColView.isPagingEnabled = true
        return mColView
    }()

    override func loadView() {
        view = UIView()
        let screenSize: CGRect = UIScreen.main.bounds
        view.frame.size.width = screenSize.width
        view.frame.size.height = screenSize.height
        view.sizeToFit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("$$$ in viewDidLoad ")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("$$$ in viewWillAppear ")
        view.addSubview(collectionView)
        view.addSubview(navBar)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("$$$ in viewWillLayoutSubviews ")
        print(" frame width: \(view.frame.size.width) height \(view.frame.size.height)")
        updateCollectionView()
        updateLayout(view.frame.size)
        self.navBar.frame = CGRect(x: 0, y: 35,
                                   width: view.frame.size.width, height: 64)
    }
    private func updateCollectionView() {
        print("$$$ in updateCollectionView ")
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
            print("mPosition before dispatch \(mPosition)")
            self.collectionView.scrollToItem(at: mPosition,
                                             at: .centeredHorizontally,
                                             animated: false)
        }

    }
    private func updateLayout(_ size: CGSize) {
        print("$$$ in updateLayout ")
        let cellWidth = size.width
        let cellHeight = size.height
        print("updateLayout cellWidth: \(cellWidth) cellHeight \(cellHeight)")
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
        self._toast.showToast(view: self.view,
                              message: "Share not yet implemented",
                              font: .boldSystemFont(ofSize: 14.0))
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
        if navBar.alpha == 1.0 {
            UIView.animate(withDuration: 0.3) {
                self.navBar.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navBar.alpha = 1.0
            }
        }
    }
}

extension UICollectionViewFlowLayout {
    override open func shouldInvalidateLayout(forBoundsChange: CGRect) -> Bool {
        return true
    }
}
