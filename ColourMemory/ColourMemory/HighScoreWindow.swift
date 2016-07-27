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
    
    func showAnimation(completion: ((Bool) -> Void)?){
        self.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.windowLevel = UIWindowLevelNormal + 1
        UIView.animateWithDuration(0.3, animations: {
            self.frame = UIScreen.mainScreen().bounds
            }, completion: {(f : Bool) -> Void in
                if completion != nil {
                    completion!(f)
                }
        })
    }
    
    func hideAnimation(completion: ((Bool) -> Void)?){
        UIView.animateWithDuration(0.3, animations: {
            self.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            }, completion: {(f : Bool) -> Void in
                self.windowLevel = UIWindowLevelNormal - 1
                UIApplication.sharedApplication().delegate?.window!?.makeKeyAndVisible()
                UIApplication.sharedApplication().delegate?.window!?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                
                let value = UIInterfaceOrientation.Portrait.rawValue
                UIDevice.currentDevice().setValue(value, forKey: "orientation")
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
