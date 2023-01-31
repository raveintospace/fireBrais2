//
//  UIButtonExtensions.swift
//  FireBraisTwo
//
//  Created by Uri on 31/1/23.
//

import UIKit

extension UIButton {
    func configureStandardUIButton(title: String, backColor: UIColor) {
        layer.cornerRadius = 10
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = backColor
    }
}
