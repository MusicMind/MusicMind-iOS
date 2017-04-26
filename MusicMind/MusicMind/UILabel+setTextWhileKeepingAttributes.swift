//
//  Created by WVDK on 2/10/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//
// https://gist.github.com/wvdk/e8992e82b04e626a862dbb991e4cbe9c
//
import UIKit

extension UILabel {
    func setTextWhileKeepingAttributes(string: String) {
        if let newAttributedText = self.attributedText {
            let mutableAttributedText = newAttributedText.mutableCopy() as! NSMutableAttributedString
            
            mutableAttributedText.mutableString.setString(string)
            
            self.attributedText = mutableAttributedText
        }
    }
}
