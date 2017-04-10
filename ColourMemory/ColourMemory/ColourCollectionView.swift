//
//  ColourCollectionView.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import Darwin

protocol ColourCollectionViewDelegate : NSObjectProtocol{
  func colourCollectionViewMemorySuccess(_ colourView: ColourCollectionView)
  func colourCollectionViewMemoryFailed(_ colourView: ColourCollectionView)
  func colourCollectionViewMemoryComplete(_ colourView: ColourCollectionView)
}

class ColourCollectionView: UIView {
  var orderArray = [Int](0...15)
  
  var flipColour = [Int]()
  var flippedView = [CardView]()
  weak var delegate : ColourCollectionViewDelegate?
  var destoried = 0
  
  var cardViews = [CardView]()
  
  override init(frame: CGRect) {
    super.init(frame : frame)
    
    restartAnimation(completion: nil)
  }
  
  func restartAnimation(completion: (() -> Void)?){
    orderArray.shuffle()
    cardViews.removeAll()
    flippedView.removeAll()
    flipColour.removeAll()
    destoried = 0
    removeAllSubViews()
    
    for i in 0...(orderArray.count - 1){
      let cid = (orderArray[i] / 2 + 1)
      
      let cardView = CardView(frame: CGRect.zero, image: UIImage(named: "Colour\(cid)"), colourId : cid)
      addSubview(cardView)
      cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colourCardDidTapped(_:))))
      cardView.tag = i
      cardViews.append(cardView)
    }
    
    self.alpha = 0
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 1
    })
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let selfWidth = frame.size.width
    let oxSpacing: CGFloat = 5
    let oySpacing: CGFloat = 5
    let cardWidth = (selfWidth - 3 * oxSpacing) / 4
    let cardHeight = cardWidth * 190 / 162
    
    var oneFrame = CGRect.zero
    for one in cardViews {
      let ny: CGFloat = CGFloat(one.tag / 4)
      let nx: CGFloat = CGFloat(one.tag % 4)
      
      oneFrame.origin.x = nx * (cardWidth + oxSpacing) + oxSpacing
      oneFrame.origin.y = ny * (cardHeight + oySpacing) + oySpacing
      oneFrame.size.width = cardWidth
      oneFrame.size.height = cardHeight
      one.frame = oneFrame
    }
    
    var selfFrame = self.frame
    selfFrame.size.height = oneFrame.maxY + oxSpacing
    self.frame = selfFrame
    
    if let superV = self.superview {
      self.center.y = superV.center.y + 20
    }
  }
  
  func destroyFlippedCard(){
    destoried += 2
    var index = 0
    for view in flippedView {
      if index == flippedView.count - 1{
        view.lp_explode(callback: {
          if self.destoried == self.orderArray.count {
            self.delegate?.colourCollectionViewMemoryComplete(self)
          }
        })
      }else{
        view.lp_explode(callback: nil)
      }
      index += 1
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
      self.flippedView.removeAll()
      self.flipColour.removeAll()
    }
  }
  
  func recoverFlippedCard(){
    for view in flippedView {
      view.flipCard(false, completion: {(complete : Bool) -> Void in
        self.flippedView.removeAll()
        self.flipColour.removeAll()
      })
    }
  }
  
  func colourCardDidTapped(_ gesture : UITapGestureRecognizer) {
    if gesture.state != .ended{
      return
    }
    
    if gesture.view == nil {
      return
    }
    if flipColour.count == 2{
      return
    }
    
    let view = gesture.view! as! CardView
    if flippedView.count == 1{
      if view == flippedView[0] {
        return
      }
    }
    self.flipColour.append(view.colourId)
    self.flippedView.append(view)
    
    var completion : ((Bool) -> Void)?
    if self.flippedView.count == 2 {
      completion = {(complete : Bool) -> Void in
        if self.flipColour[0] == self.flipColour[1]{
          self.delegate?.colourCollectionViewMemorySuccess(self)
        }else{
          self.delegate?.colourCollectionViewMemoryFailed(self)
        }
      }
    }
    
    view.flipCard(true, completion: completion)
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
