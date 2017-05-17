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
    public func setBackgroundColor(color: UIColor?, forState state: UIControlState) {
        
        let saveCornerRadius = layer.cornerRadius
        
        guard let color = color else { return setBackgroundImage(nil, for: state) }
        setBackgroundImage(UIImage.imageColored(color: color), for: state)
        
        layer.cornerRadius = saveCornerRadius
    }
}

