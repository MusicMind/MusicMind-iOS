//
//  UIImage+imageColored.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/4/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

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
