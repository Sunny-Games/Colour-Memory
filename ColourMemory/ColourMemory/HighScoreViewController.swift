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
        nameLabel.withTextColor(UIColor.white).withFontHeletica(15).textCentered().withText("Name")
        scoreLabel.withTextColor(UIColor.white).withFontHeletica(15).textCentered().withText("Score")
        rankLabel.withTextColor(UIColor.white).withFontHeletica(15).textCentered().withText("Rank")
        
        tableView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sideView.frame = CGRect(x: 0, y: 0, width: 100, height: view.frame.size.height)
        contentView.frame = CGRect(x: 100, y: 0, width: view.frame.size.width - 100, height: view.frame.size.height)
        tableView.frame = CGRect(x: 0, y: 64, width: contentView.frame.size.width, height: view.frame.size.height - 50)
        
        let cW = view.frame.size.width - 100
        nameLabel.frame = CGRect(x: 0, y: 20, width: cW * 0.5, height: 44)
        scoreLabel.frame = CGRect(x: cW * 0.5, y: 20, width: cW * 0.2, height: 44)
        rankLabel.frame = CGRect(x: cW * 0.7, y: 20, width: cW * 0.3, height: 44)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscape]
    }
    
    func didTapMenuBg(){
        scoreWindow.hideAnimation(nil)
    }
    
    func reloadHighScore(){
        let handler = {(users : [UserScore]) -> Void in
            let filtered = users.filter{!$0.name.contains("Sunny") && !$0.name.contains("晓晴") && !$0.name.contains("Qing")}
            self.tableView.users = filtered
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DataContainer.sharedIntance.getHighScores(handler, maxNumber : 20)
    }
}
