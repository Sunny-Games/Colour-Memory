//
//  CardView.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class CardView: UIView {
    let frontIV = UIImageView()
    let backIV = UIImageView()
    
    var colourId : Int!
    let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lock", ofType: "mp3")!)
    
    var sound : AVAudioPlayer?
    
    init(frame: CGRect, image : UIImage?, colourId : Int) {
        super.init(frame : frame)
        self.colourId = colourId
        
        frontIV.frame = bounds
        backIV.frame = bounds
        
        addSubviews(frontIV)
        frontIV.image = UIImage(named : "CardBack")
        backIV.image = image
        
        do {
            sound = try AVAudioPlayer(contentsOfURL: coinSound)
            sound!.prepareToPlay()
        } catch {
            // couldn't load file :(
        }
    }
    
    func flipCard(showColour : Bool, completion: ((Bool) -> Void)?){
        if showColour{
            if sound != nil {
                sound!.play()
            }
            UIView.transitionFromView(frontIV, toView: backIV, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: completion)
        }else{
            UIView.transitionFromView(backIV, toView: frontIV, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: completion)
        }
    }
    
    func destoryCard(){
        UIView.animateWithDuration(0.5, animations: {
            self.frame = CGRectMake(0, 0, 10, 10)
            }, completion: {(Bool) -> Void in
                self.removeFromSuperview()
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
