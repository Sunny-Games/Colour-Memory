//
//  HighScoreWindow.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class HighScoreWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func showAnimation(_ completion: ((Bool) -> Void)?){
        self.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.windowLevel = UIWindowLevelNormal + 1
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = UIScreen.main.bounds
            }, completion: {(f : Bool) -> Void in
                if completion != nil {
                    completion!(f)
                }
        })
    }
    
    func hideAnimation(_ completion: ((Bool) -> Void)?){
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: {(f : Bool) -> Void in
                self.windowLevel = UIWindowLevelNormal - 1
                UIApplication.shared.delegate?.window!?.makeKeyAndVisible()
                UIApplication.shared.delegate?.window!?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
              //  UIApplication.sharedApplication().setStatusBarOrientation(.Portrait, animated: false)
                if completion != nil {
                    completion!(f)
                }
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
