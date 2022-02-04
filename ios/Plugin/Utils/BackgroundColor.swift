//
//  BackgroundColor.swift
//  CapacitorCommunityPhotoviewer
//
//  Created by  Quéau Jean Pierre on 04/02/2022.
//

import UIKit
class BackgroundColor {
    func setBackColor(color: String) -> UIColor {
        var retColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        switch color {
        case "white":
            retColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        case "ivory":
            retColor = UIColor(red: 255, green: 255, blue: 240, alpha: 1)
        case "lightgrey":
            retColor = UIColor(red: 211, green: 211, blue: 211, alpha: 1)
        case "darkgrey":
            retColor = UIColor(red: 169, green: 169, blue: 169, alpha: 1)
        case "dimgrey":
            retColor = UIColor(red: 105, green: 105, blue: 105, alpha: 1)
        case "grey":
            retColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1)
        default:
            retColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return retColor
    }
}
