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
    func colourCollectionViewMemorySuccess(colourView: ColourCollectionView)
    func colourCollectionViewMemoryFailed(colourView: ColourCollectionView)
    func colourCollectionViewMemoryComplete(colourView: ColourCollectionView)
}

class ColourCollectionView: UIView {
    var orderArray = [Int](0...15)
    
    var flipColour = [Int]()
    var flippedView = [CardView]()
    weak var delegate : ColourCollectionViewDelegate?
    var destoried = 0
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        restartAnimation(false, completion: nil)
    }
    
    func restartAnimation(animated : Bool = true, completion: (() -> Void)?){
        orderArray.shuffle()
        
        flippedView.removeAll()
        flipColour.removeAll()
        destoried = 0
        removeAllSubViews()
        
        let width = (frame.size.width - 3 * 5) / 4
        let height = width * 190 / 152
        
        for i in 0...(orderArray.count - 1){
            let ox = 3 + (CGFloat(i) % 4) * (3 + width)
            let oy = CGFloat((Int(i) / 4)) * (height + 5)
            
            let cid = (orderArray[i] / 2 + 1)
            
            var offSet : CGFloat = 0
            if animated {
                offSet += frame.size.height + 100
            }
            
            let view = CardView(frame: CGRectMake(ox, oy + offSet, width, height), image: UIImage(named: "Colour\(cid)"), colourId : cid)
            addSubview(view)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colourCardDidTapped(_:))))
            
            if animated {
                UIView.animateWithDuration(1, animations: {
                    view.frame = CGRectMake(ox, oy, width, height)
                    }, completion: {(Bool) -> Void in
                        if completion != nil {
                            completion!()
                        }
                })
            }
        }
    }
    
    func destroyFlippedCard(){
        destoried += 2
        var index = 0
        for view in flippedView {
            if index == flippedView.count - 1{
                view.lp_explodeWithCallback({
                    if self.destoried == self.orderArray.count {
                        self.delegate?.colourCollectionViewMemoryComplete(self)
                    }
                })
            }else{
                view.lp_explodeWithCallback(nil)
            }
            index += 1
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
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
    
    func colourCardDidTapped(gesture : UITapGestureRecognizer) {
        if gesture.state != .Ended{
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
