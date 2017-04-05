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
        
        contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
        backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.register(UserScoreTableCell.self, forCellReuseIdentifier: UserScoreTableCellIdentity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserScoreTableCellIdentity) as! UserScoreTableCell
        let oneContact = users[indexPath.row]
        cell.selectionStyle = .none
        cell.setNameScore(oneContact.name, score: oneContact.score, rank: oneContact.rank)
        
        return cell
    }
}

class UserScoreTableCell: UITableViewCell {
    fileprivate let nameLabel = UILabel()
    fileprivate let scoreLabel = UILabel()
    fileprivate let rankLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews(nameLabel, scoreLabel, rankLabel)
        backgroundColor = UIColor.blackDrak()
        
        nameLabel.withTextColor(UIColor.white).withFontHeletica(15).textCentered()
        scoreLabel.withTextColor(UIColor.white).withFontHeletica(15).textCentered()
        rankLabel.withTextColor(UIColor.white).withFontHeletica(15).textCentered()
        
        let border = UIView()
        border.backgroundColor = UIColor.white
        addSubview(border)
        
        constrain(nameLabel, scoreLabel, rankLabel, border, self) { nameLabel, scoreLabel, rankLabel, border, superView in
            nameLabel.left == superView.left
            scoreLabel.left == nameLabel.right
            rankLabel.left == scoreLabel.right
            rankLabel.right == superView.right
            
            nameLabel.bottom == superView.bottom - 3
            scoreLabel.bottom == nameLabel.bottom
            rankLabel.bottom == nameLabel.bottom
            
            nameLabel.width == superView.width * 0.5
            scoreLabel.width == superView.width * 0.2
            
            border.left == superView.left + 5
            border.right == superView.right - 5
            border.bottom == superView.bottom
            border.height == 0.5
        }
    }
    
    func setNameScore(_ name : String, score : Int, rank : Int){
        nameLabel.withText(name)
        scoreLabel.withText("\(score)")
        rankLabel.withText("\(rank)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

 
