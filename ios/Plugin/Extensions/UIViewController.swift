//
//  UIViewController.swift
//  CapacitorCommunityPhotoviewer
//
//  Created by  Quéau Jean Pierre on 03/10/2022.
//

import UIKit
extension UIViewController {

    func showToast(message: String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }
    func dismissWithTransition(swipeDirection: String) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        if swipeDirection == "up" {
            transition.subtype = CATransitionSubtype.fromTop
        } else if swipeDirection == "down" {
            transition.subtype = CATransitionSubtype.fromBottom
        } else {
            transition.subtype = CATransitionSubtype.fromRight
        }

        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }

}
