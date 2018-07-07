//
//  UIColor Extension.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 07/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

// UIColor class extension to use hex color values easily
extension UIColor {
    // Source:
    // https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
