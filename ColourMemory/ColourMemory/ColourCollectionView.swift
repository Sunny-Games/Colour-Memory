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
}

class ColourCollectionView: UIView {
    var orderArray = [Int](0...15)
    
    var flipColour = [Int]()
    var flippedView = [CardView]()
    weak var delegate : ColourCollectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        orderArray.shuffle()
        
        let width = (frame.size.width - 3 * 5) / 4
        let height = width * 190 / 152
        
        for i in 0...(orderArray.count - 1){
            let ox = 3 + (CGFloat(i) % 4) * (3 + width)
            let oy = CGFloat((Int(i) / 4)) * (height + 5)
            
            let cid = (orderArray[i] / 2 + 1)
            let view = CardView(frame: CGRectMake(ox, oy, width, height), image: UIImage(named: "Colour\(cid)"), colourId : cid)
            addSubview(view)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colourCardDidTapped(_:))))
        }
    }
    
    func destroyFlippedCard(){
        for view in flippedView {
            view.lp_explodeWithCallback(nil)
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
        if gesture.view == nil {
            return
        }
        if flipColour.count == 2{
            return
        }
        
        let view = gesture.view! as! CardView
        self.flipColour.append(view.colourId)
        self.flippedView.append(view)

        let completion = {(complete : Bool) -> Void in
            if self.flipColour.count == 2 {
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
