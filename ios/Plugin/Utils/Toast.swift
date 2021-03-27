//
//  Toast.swift
//  Capacitor
//
//  Created by  Quéau Jean Pierre on 27/02/2021.
//

import UIKit

class Toast {
    func showToast(view: UIView, message: String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 100,
                                               y: view.frame.size.height-120,
                                               width: 200, height: 50))
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }

}
