//
//  ScoreTableView.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

let UserScoreTableCellIdentity = "UserScoreTableCellIdentity"

class ScoreTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var users = [UserScore]()
 
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        backgroundColor = UIColor.whiteColor()
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .None
        self.showsVerticalScrollIndicator = false
        self.registerClass(UserScoreTableCell.self, forCellReuseIdentifier: UserScoreTableCellIdentity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserScoreTableCellIdentity) as! UserScoreTableCell
        let oneContact = users[indexPath.row]
        cell.selectionStyle = .None
        cell.setNameScore(oneContact.name, score: oneContact.score)
        
        return cell
    }
}

class UserScoreTableCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        self.addSubviews(nameLabel, scoreLabel)
        backgroundColor = UIColor.blackDrak()
        
        nameLabel.withTextColor(UIColor.whiteColor()).withFontHeletica(15).textCentered()
        scoreLabel.withTextColor(UIColor.whiteColor()).withFontHeletica(15).textCentered()
        
        let border = UIView()
        border.backgroundColor = UIColor.whiteColor()
        addSubview(border)
        
        constrain(nameLabel, scoreLabel, border, self) { nameLabel, scoreLabel, border, superView in
            nameLabel.left == superView.left
            scoreLabel.right == superView.right
            nameLabel.bottom == superView.bottom - 3
            scoreLabel.bottom == nameLabel.bottom
            nameLabel.width == superView.width / 2
            scoreLabel.width == superView.width / 2
            
            border.left == superView.left + 23
            border.right == superView.right - 23
            border.bottom == superView.bottom
            border.height == 0.5
        }
    }
 
    func setNameScore(name : String, score : Int){
        nameLabel.withText(name)
        scoreLabel.withText("\(score)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

 