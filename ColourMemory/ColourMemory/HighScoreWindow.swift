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
                if completion != nil {
                    completion!(f)
                }
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
