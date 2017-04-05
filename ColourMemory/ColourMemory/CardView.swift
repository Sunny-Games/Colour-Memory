//
//  CardView.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit


class CardView: UIView {
    let frontIV = UIImageView()
    let backIV = UIImageView()
    
    var colourId : Int!
    
  
    init(frame: CGRect, image : UIImage?, colourId : Int) {
        super.init(frame : frame)
        
        self.colourId = colourId
        
        frontIV.frame = bounds
        backIV.frame = bounds
        
        addSubviews(frontIV)
        frontIV.image = UIImage(named : "CardBack")
        backIV.image = image
    }
    
    func flipCard(_ showColour : Bool, completion: ((Bool) -> Void)?){
        if showColour{
            SoundManager.sharedInstance.playFlipSound()
            UIView.transition(from: frontIV, to: backIV, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromRight, completion: completion)
        }else{
            UIView.transition(from: backIV, to: frontIV, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromRight, completion: completion)
        }
    }
    
    func destoryCard(){
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            }, completion: {(Bool) -> Void in
                self.removeFromSuperview()
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
