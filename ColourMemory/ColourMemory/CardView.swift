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
    
    func flipCard(showColour : Bool){
        if showColour{
            UIView.transitionFromView(frontIV, toView: backIV, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        }else{
            UIView.transitionFromView(backIV, toView: frontIV, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        }
    }
    
    func destoryCard(){
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
