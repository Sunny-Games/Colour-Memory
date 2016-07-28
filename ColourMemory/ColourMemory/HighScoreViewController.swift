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
    let tableView = ScoreTableView()
    
    let nameLabel = UILabel()
    let scoreLabel = UILabel()
    let rankLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(fromHexString: "242424", alpha: 0.5)
        
        sideView.addGestureRecognizer(UITapGestureRecognizer(target : self, action: #selector(didTapMenuBg)))
        view.addSubview(sideView)
        
        contentView.backgroundColor = UIColor.blackDrak()
        view.addSubview(contentView)
        
        contentView.addSubviews(nameLabel, scoreLabel, rankLabel)
        nameLabel.withTextColor(UIColor.whiteColor()).withFontHeletica(15).textCentered().withText("Name")
        scoreLabel.withTextColor(UIColor.whiteColor()).withFontHeletica(15).textCentered().withText("Score")
        rankLabel.withTextColor(UIColor.whiteColor()).withFontHeletica(15).textCentered().withText("Rank")
        
        tableView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sideView.frame = CGRectMake(0, 0, 100, view.frame.size.height)
        contentView.frame = CGRectMake(100, 0, view.frame.size.width - 100, view.frame.size.height)
        tableView.frame = CGRectMake(0, 64, contentView.frame.size.width, view.frame.size.height - 50)
        
        let cW = view.frame.size.width - 100
        nameLabel.frame = CGRectMake(0, 20, cW * 0.5, 44)
        scoreLabel.frame = CGRectMake(cW * 0.5, 20, cW * 0.2, 44)
        rankLabel.frame = CGRectMake(cW * 0.7, 20, cW * 0.3, 44)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.Landscape]
    }
    
    func didTapMenuBg(){
        scoreWindow.hideAnimation(nil)
    }
    
    func reloadHighScore(){
        let handler = {(users : [UserScore]) -> Void in
            self.tableView.users = users
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        DataContainer.sharedIntance.getHighScores(handler, maxNumber : 20)
    }
}
