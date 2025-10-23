//
//  CollectionViewController.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 25/02/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import UIKit

import SDWebImage

class CollectionViewController: UIViewController {

    //    public var imageList: [[String: String]]?
    //    public var options: Any?

    private var _numCells: CGFloat = 3
    private var _numImages: Int = 0
    private var _imageList: [[String: String]] = []
    private var _options: [String: Any] = [:]
    private var _numLayoutCells: CGFloat = 3
    private var _cellWidth: CGFloat = 50
    private var _cellHeight: CGFloat = 50
    private var _backgroundColor: String = "black"
    private var _backColor: BackgroundColor = BackgroundColor()
    private var _colorRange: [String] = ["white", "ivory", "lightgrey"]
    private var _btColor: UIColor = UIColor.white

    lazy var layout: UICollectionViewFlowLayout = { ()
        -> UICollectionViewFlowLayout in
        let mLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        mLayout.scrollDirection = .vertical
        mLayout.minimumLineSpacing = 1
        mLayout.minimumInteritemSpacing = 1
        updateLayout(mLayout, size: CGSize(width: view.frame.size.width,
                                           height: view.frame.size.height))

        return mLayout
    }()

    lazy var collectionView: UICollectionView = {
        let mColView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        mColView.register(
            CollectionViewCell.self, forCellWithReuseIdentifier:
                CollectionViewCell.identifier)
        mColView.dataSource = self
        mColView.backgroundColor = .darkGray

        return mColView
    }()
    lazy var mNavBar: UINavigationBar = { () -> UINavigationBar in

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
        image = UIImage(systemName: "multiply.circle.fill",
                        withConfiguration: configuration)
        bClose.image = image?.withTintColor(_btColor, renderingMode: .alwaysOriginal)
        bClose.tintColor = _btColor
        bClose.action = #selector(closeButtonTapped)
        return bClose
    }()

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
            if self._options.keys.contains("spancount") {
                if let spc = self._options["spancount"] as? Int {
                    self._numCells = CGFloat(spc)
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

    // MARK: - loadView

    override func loadView() {

        view = UIView()
        let screenSize: CGRect = UIScreen.main.bounds
        _numLayoutCells = _numCells
        view.frame.size.width = screenSize.width
        view.frame.size.height = screenSize.height
        view.sizeToFit()
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        SDImageCache.shared.clear(with: .all, completion: nil)

    }

    // MARK: - viewDidDisappear

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        destroyAllGestures()
    }

    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(collectionView)
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
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = mClose
        mNavBar.setItems([navigationItem], animated: false)
        mNavBar.frame = CGRect(x: 0, y: 35,
                               width: view.frame.size.width, height: 64)
        view.addSubview(mNavBar)

    }

    // MARK: - viewWillLayoutSubviews

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout(layout, size: view.frame.size)
    }

    // MARK: - updateLayout

    private func updateLayout(_ layout: UICollectionViewFlowLayout, size: CGSize) {
        if size.width > size.height {
            _numLayoutCells = _numCells + 1
            _cellWidth = (size.width/_numLayoutCells)-1
            _cellHeight = (size.width/_numLayoutCells)-1

        } else {
            _numLayoutCells = _numCells
            _cellWidth = (size.width/_numLayoutCells)-1
            _cellHeight = (size.width/_numLayoutCells)-1

        }
        layout.itemSize = CGSize(width: _cellWidth,
                                 height: _cellWidth)

    }

    // MARK: - viewWillTransition

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        updateLayout(layout, size: size)
    }

    // MARK: Add Gesture Recognizers

    func addGestureRecognizers() {
        let singleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(didSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        collectionView.addGestureRecognizer(singleTapGesture)

    }

    // MARK: - destroyAllGestures

    func destroyAllGestures() {
        self.collectionView.gestureRecognizers?.removeAll()
    }

    // MARK: - closeButtonTapped

    @objc func closeButtonTapped() {
        let vId: [String: Any] = ["result": true]
        NotificationCenter.default.post(name: .photoviewerExit,
                                        object: nil,
                                        userInfo: vId)

        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - didSingleTap

    @objc
    func didSingleTap(_ recognizer: UITapGestureRecognizer) {

        guard (recognizer.view as? UICollectionView) != nil else {
            print("Error not an Image")
            return
        }
        let position = recognizer.location(in: self.collectionView)
        guard let index = self.collectionView.indexPathForItem(at: position) else {
            print("Error Image not in collectionView")
            return
        }
        showModalSlider(position: index, imageList: imageList, mode: "gallery", options: options)
    }

    // MARK: - showModalSlider

    func showModalSlider(position: IndexPath,
                         imageList: [[String: String]],
                         mode: String,
                         options: [String: Any]) {
        self.showToast(message: "Image \(position)",
                       font: .systemFont(ofSize: 14.0))
        let sliderVC = SliderViewController()
        sliderVC.modalPresentationStyle = .overFullScreen
        sliderVC.position = position
        sliderVC.imageList = imageList
        sliderVC.mode = mode
        sliderVC.options = options
        present(sliderVC, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension CollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return _numImages
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell
                .identifier, for: indexPath) as? CollectionViewCell
        if let mCell = cell {
            if let imageUrl = imageList[indexPath.row]["url"] {
                mCell.configure(imageUrl: imageUrl)
                return mCell
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
