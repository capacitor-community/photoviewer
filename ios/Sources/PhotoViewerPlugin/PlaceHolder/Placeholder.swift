//
//  Placeholder.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 26/02/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import UIKit

class Placeholder: UIView {
    private var _phtext: String = "Loading"
    private var _phcolor: UIColor = .black
    private var _label: UILabel?

    override required init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Set-up Placeholder Text

    var phtext: String {
        get {
            return self._phtext
        }
        set {
            self._phtext = newValue
        }
    }

    // MARK: - Set-up Placeholder Text Color

    var phcolor: UIColor {
        get {
            return self._phcolor
        }
        set {
            self._phcolor = newValue
        }
    }

    // MARK: - initialize

    private func initialize() {
        if _label == nil {
            _label = UILabel()
            _label?.numberOfLines = 0
            _label?.textAlignment = .center
            if let lab = _label {
                addSubview(lab)
                // center the label inside the placeholder space
                _label?.translatesAutoresizingMaskIntoConstraints = false
                _label?.centerXAnchor.constraint(equalTo: centerXAnchor)
                    .isActive = true
                _label?.centerYAnchor.constraint(equalTo: centerYAnchor)
                    .isActive = true
                _label?.text =  phtext
                _label?.font = UIFont.boldSystemFont(ofSize: 20.0)
                _label?.textColor = phcolor
            } else {
                _label = nil
            }
        }
    }
}
