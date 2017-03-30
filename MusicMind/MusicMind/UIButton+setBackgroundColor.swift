//
//  UIButton+setBackgroundColor.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/30/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

// Thanks to https://github.com/acani/UIButtonBackgroundColor

import UIKit

extension UIButton {
    public func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        
        let saveCornerRadius = layer.cornerRadius
        
        setBackgroundImage(UIImage.imageColored(color: color), for: state)
        
        layer.cornerRadius = saveCornerRadius
    }
}

extension UIImage {
    public class func imageColored(color: UIColor) -> UIImage! {
        let onePixel = 1 / UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: onePixel, height: onePixel)
        UIGraphicsBeginImageContextWithOptions(rect.size, color.cgColor.alpha == 1, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor( color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
