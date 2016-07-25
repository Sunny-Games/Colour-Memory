//
//  ViewController.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black24()
        
        let height = (view.frame.size.width - 15) * 190 / 152 + 15
        let spacing = (view.frame.size.height - height - 64) / 2
        
        let cardView = ColourCollectionView(frame : CGRectMake(0, 64 + spacing, view.frame.size.width, height))
        view.addSubview(cardView)
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

