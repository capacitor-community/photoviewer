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

        contentView.backgroundColor = .systemRed
        if #available(iOS 13, *) {
        } else {
            contentView.addSubview(mPlaceholder)
        }
        contentView.addSubview(mImageView)
        contentView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13, *) {
        } else {
            mPlaceholder.frame = CGRect(x: 5, y: (contentView.frame.size.height/2)-20,
                                        width: contentView.frame.size.width-10, height: 40)
        }
        mImageView.frame = CGRect(x: 0, y: 0,
                                  width: contentView.frame.size.width,
                                  height: contentView.frame.size.height)
    }

    // MARK: - configure

    func configure(imageUrl: String) {
        let imgPlaceHolder: UIImage?
        if #available(iOS 13, *) {
            imgPlaceHolder = UIImage(systemName: "livephoto.slash")
        } else {
            imgPlaceHolder = nil
        }
        mImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: imgPlaceHolder)

    }

    // MARK: - prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()
        mImageView.image = nil
    }
}
