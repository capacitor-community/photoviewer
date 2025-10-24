//
//  CollectionViewCell.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 25/02/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"

    // MARK: - Set-up Views

    private let mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let mPlaceholder: Placeholder = {
        let placeholder = Placeholder(frame: .zero)
        placeholder.phtext = "Loading..."
        return placeholder

    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .lightGray
        contentView.addSubview(mImageView)
        contentView.clipsToBounds = true
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
    }

    // MARK: - configure

    func configure(imageUrl: String) {
        if imageUrl.prefix(4) == "http" || imageUrl.contains("base64") {
            let imgPlaceHolder: UIImage?
            imgPlaceHolder = UIImage(systemName: "livephoto.slash")
            mImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: imgPlaceHolder)
        }
        if imageUrl.prefix(38) ==
            "file:///var/mobile/Media/DCIM/100APPLE" ||
            imageUrl.prefix(38) ==
            "capacitor://localhost/_capacitor_file_" {
            let image: UIImage = UIImage()
            self.mImageView.image = image.getImage(path: imageUrl,
                                                   placeHolder: "livephoto.slash")
            //            self.mImageView
            //                .getImageFromInternalUrl(url: imageUrl,
            //                                         imgPlaceHolder: imgPlaceHolder)
        }

    }

    // MARK: - prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()
        mImageView.image = nil
    }
}
