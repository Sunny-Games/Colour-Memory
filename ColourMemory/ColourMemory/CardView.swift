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
    
    clipsToBounds = true
    
    self.colourId = colourId
    
    addSubviews(frontIV)

    frontIV.image = UIImage(named : "CardBack")
    backIV.image = image
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backIV.frame = bounds
    frontIV.frame = bounds
  }
  
  func flipCard(_ showColour : Bool, completion: ((Bool) -> Void)?){
    if showColour{
      SoundManager.sharedInstance.playFlipSound()
      UIView.transition(from: frontIV, to: backIV, duration: 0.2, options: UIViewAnimationOptions.transitionFlipFromRight, completion: completion)
    }else{
      UIView.transition(from: backIV, to: frontIV, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromRight, completion: completion)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
