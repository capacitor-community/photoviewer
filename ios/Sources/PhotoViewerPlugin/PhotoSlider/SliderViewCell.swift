//
//  SliderViewCell.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 25/02/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import UIKit
import SDWebImage

protocol SliderViewCellDelegate: AnyObject {
    func didShowButtons(tapCell: Bool)
    func didZoom(point: CGPoint)
}

class SliderViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let identifier = "SliderViewCell"
    weak var delegate: SliderViewCellDelegate?

    private var _options: [String: Any] = [:]
    private var _isTitle: Bool = true
    private var _backgroundColor: String = "black"
    private var _backColor: BackgroundColor = BackgroundColor()

    // MARK: - Set-up options

    var options: [String: Any] {
        get {
            return self._options
        }
        set {
            self._options = newValue
            if self._options.keys.contains("title") {
                if let isTitle = self._options["title"] as? Bool {
                    self._isTitle = isTitle
                }
            }
            if self._isTitle {
                contentView.addSubview(mLabel)
            }
            if self._options.keys.contains("backgroundcolor") {
                if let backgroundColor = self._options["backgroundcolor"]
                    as? String {
                    self._backgroundColor = backgroundColor
                    contentView.backgroundColor =  _backColor
                        .setBackColor(color: _backgroundColor)
                }
            } else {
                contentView.backgroundColor =  _backColor
                    .setBackColor(color: _backgroundColor)
            }
        }
    }

    // MARK: - Set-up Views

    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var mLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textAlignment = .center
        label.clipsToBounds = true
        label.textColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mImageView)
        contentView.clipsToBounds = true
        addGestureRecognizers()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        mImageView.frame = CGRect(x: 0, y: 0,
                                  width: contentView.frame.size.width,
                                  height: contentView.frame.size.height)
        mLabel.frame = CGRect(x: 5, y: mImageView.frame.size.height-100,
                              width: mImageView.frame.size.width-10, height: 100)
    }

    // MARK: - configure

    func configure(imageUrl: String, title: String) {
        if imageUrl.prefix(4) == "http" || imageUrl.contains("base64") {
            mImageView.sd_setImage(with: URL(string: imageUrl),
                                   placeholderImage: nil)
        }
        if imageUrl.prefix(38) ==
            "file:///var/mobile/Media/DCIM/100APPLE" ||
            imageUrl.prefix(38) ==
            "capacitor://localhost/_capacitor_file_" {

            let image: UIImage = UIImage()
            self.mImageView.image = image.getImage(path: imageUrl,
                                                   placeHolder: "livephoto.slash")
        }

        mLabel.text = title
    }

    // MARK: - prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()
        mImageView.image = nil
        mLabel.text = nil
    }

    // MARK: Add Gesture Recognizers

    func addGestureRecognizers() {
        let singleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        mImageView.addGestureRecognizer(singleTapGesture)
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        mImageView.addGestureRecognizer(doubleTapRecognizer)

        singleTapGesture.require(toFail: doubleTapRecognizer)
    }
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        if let mDelegate = delegate {
            mDelegate.didShowButtons(tapCell: true)
        } else {
            print("No delegate for that cell")
        }
    }
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let pointInView: CGPoint = recognizer.location(in: mImageView)
        if let mDelegate = delegate {
            mDelegate.didZoom(point: pointInView)
        } else {
            print("No delegate for that cell")
        }
    }
}
