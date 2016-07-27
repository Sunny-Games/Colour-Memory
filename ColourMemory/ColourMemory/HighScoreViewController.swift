//
//  HighScoreViewController.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    let contentView = UIView()
    let sideView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.backgroundColor = UIColor(fromHexString: "242424", alpha: 0.5)
        
        sideView.addGestureRecognizer(UITapGestureRecognizer(target : self, action: #selector(didTapMenuBg)))
        view.addSubview(sideView)
        
        contentView.backgroundColor = UIColor.blackDrak()
        view.addSubview(contentView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sideView.frame = CGRectMake(0, 0, 100, view.frame.size.height)
        contentView.frame = CGRectMake(100, 0, view.frame.size.width - 100, view.frame.size.height)
    }
    
    func didTapMenuBg(){
        scoreWindow.hideAnimation(nil)
    }
    
    func reloadHighScore(){
        
    }
}
