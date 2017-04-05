//
//  ViewExtensions.swift
//  DejaFashion
//
//  Created by jiao qing on 10/12/15.
//  Copyright © 2015 Mozat. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views : UIView...) {
        for v in views {
            self.addSubview(v)
        }
    }
}

extension UILabel {
    func withFontHeletica(_ size : CGFloat) -> UILabel{
        self.font = UIFont.regularFont(size)
        return self
    }
    
    func withFontHeleticaMedium(_ size : CGFloat) -> UILabel{
        self.font = UIFont.mediumfont(size)
        return self
    }
    
    func withFontHeleticaBold(_ size : CGFloat) -> UILabel{
        self.font = UIFont.boldFont(size)
        return self
    }
    
    func withFontHeleticaLight(_ size : CGFloat) -> UILabel{
        self.font = UIFont.lightfont(size)
        return self
    }
    
    func textCentered() -> UILabel {
        self.textAlignment = NSTextAlignment.center
        return self
    }
    
    func withTextColor(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    func withText(_ text: String) -> UILabel {
        self.text = text
        return self
    }
}


extension UIButton {
    func withFontHeletica(_ size : CGFloat) -> UIButton{
        self.titleLabel!.font = UIFont.regularFont(size)
        return self
    }
    
    func withFontHeleticaBold(_ size : CGFloat) -> UIButton{
        self.titleLabel!.font = UIFont.boldFont(size)
        return self
    }
    
    func withFontHeleticaMedium(_ size : CGFloat) -> UIButton{
        self.titleLabel!.font = UIFont.mediumfont(size)
        return self
    }
    
    func withTitle(_ title : String) -> UIButton {
        self.setTitle(title, for: UIControlState())
        return self
    }
    
    func withFont(_ font : UIFont) -> UIButton {
        self.titleLabel?.font = font
        return self
    }
    
    func withTitleColor(_ color : UIColor) -> UIButton {
        self.setTitleColor(color, for: UIControlState())
        return self
    }
    
    func withHighlightTitleColor(_ color : UIColor) -> UIButton {
        self.setTitleColor(color, for: .highlighted)
        return self
    }
    
    func withImage(_ image : UIImage?) -> UIButton {
        setImage(image, for: state)
        return self
    }
    
    func withBackgroundImage(_ image : UIImage?) -> UIButton {
        setBackgroundImage(image, for: state)
        return self
    }
}

extension UIColor {
    static func black24() -> UIColor {
        return UIColor(fromHexString: "242424")
    }
    
    static func blackDrak() -> UIColor {
        return UIColor(fromHexString: "0B0A10")
    }
    
    static func gray81Color() -> UIColor {
        return UIColor(fromHexString: "818181")
    }
}

 
