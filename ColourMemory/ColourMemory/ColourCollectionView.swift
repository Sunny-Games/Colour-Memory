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

            let view = CardView(frame: CGRectMake(ox, oy, width, height), image: UIImage(named: "Colour\(i/2 + 1)"), colourId : (i/2 + 1))
            addSubview(view)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colourCardDidTapped(_:))))
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
        view.flipCard(true)
        
        if flipColour.count > 0 {
            flippedView.append(view)
            let pre = flipColour[0]
            if pre == view.colourId{
                delegate?.colourCollectionViewMemorySuccess(self)
            }else{
                delegate?.colourCollectionViewMemoryFailed(self)
            }
        }else{
            flipColour.append(view.colourId)
            flippedView.append(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
