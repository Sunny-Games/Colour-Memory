//
//  ViewExtensions.swift
//  DejaFashion
//
//  Created by jiao qing on 10/12/15.
//  Copyright © 2015 Mozat. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(views : UIView...) {
        for v in views {
            self.addSubview(v)
        }
    }
}

extension UILabel {
    func withFontHeletica(size : CGFloat) -> UILabel{
        self.font = UIFont.regularFont(size)
        return self
    }
    
    func withFontHeleticaMedium(size : CGFloat) -> UILabel{
        self.font = UIFont.mediumfont(size)
        return self
    }
    
    func withFontHeleticaBold(size : CGFloat) -> UILabel{
        self.font = UIFont.boldFont(size)
        return self
    }
    
    func withFontHeleticaLight(size : CGFloat) -> UILabel{
        self.font = UIFont.lightfont(size)
        return self
    }
    
    func textCentered() -> UILabel {
        self.textAlignment = NSTextAlignment.Center
        return self
    }
    
    func withTextColor(color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    func withText(text: String) -> UILabel {
        self.text = text
        return self
    }
}


extension UIButton {
    func withFontHeletica(size : CGFloat) -> UIButton{
        self.titleLabel!.font = UIFont.regularFont(size)
        return self
    }
    
    func withFontHeleticaBold(size : CGFloat) -> UIButton{
        self.titleLabel!.font = UIFont.boldFont(size)
        return self
    }
    
    func withFontHeleticaMedium(size : CGFloat) -> UIButton{
        self.titleLabel!.font = UIFont.mediumfont(size)
        return self
    }
    
    func withTitle(title : String) -> UIButton {
        self.setTitle(title, forState: .Normal)
        return self
    }
    
    func withFont(font : UIFont) -> UIButton {
        self.titleLabel?.font = font
        return self
    }
    
    func withTitleColor(color : UIColor) -> UIButton {
        self.setTitleColor(color, forState: .Normal)
        return self
    }
    
    func withHighlightTitleColor(color : UIColor) -> UIButton {
        self.setTitleColor(color, forState: .Highlighted)
        return self
    }
    
    func withImage(image : UIImage?) -> UIButton {
        setImage(image, forState: state)
        return self
    }
    
    func withBackgroundImage(image : UIImage?) -> UIButton {
        setBackgroundImage(image, forState: state)
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

 