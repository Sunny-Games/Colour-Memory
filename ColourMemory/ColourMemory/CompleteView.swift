//
//  CompleteView.swift
//  ColourMemory
//
//  Created by jiao qing on 26/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

protocol CompleteViewDelegate : NSObjectProtocol{
    func completeViewDidSubmit(_ completeView: CompleteView, name : String)
    func completeViewDidCancel(_ completeView: CompleteView)
}

class CompleteView: UIView, UITextFieldDelegate {
    weak var delegate : CompleteViewDelegate?
    let textField = UITextField()
    let hintLabel = UILabel()
    
    let rankLabel = UILabel()
    let scoreLabel = UILabel()
    let nameLabel = UILabel()
    let border = UIView()
    let doneBtn = UIButton()
    let cancelBtn = UIButton()
    
    let active = UIActivityIndicatorView()
    
    init(frame: CGRect, score : Int) {
        super.init(frame : frame)
        
        clipsToBounds = true
        backgroundColor = UIColor(fromHexString: "0F0E14")
        
        rankLabel.frame = CGRect(x: 0, y: 10, width: frame.size.width, height: 36)
        rankLabel.text = "Rank"
        rankLabel.withFontHeleticaMedium(16).textCentered()
        addSubviews(rankLabel)
        
        active.activityIndicatorViewStyle = .white
        active.frame = rankLabel.frame
        active.startAnimating()
        addSubview(active)
        
        scoreLabel.frame = CGRect(x: 0, y: rankLabel.frame.maxY, width: frame.size.width, height: 36)
        scoreLabel.withTextColor(UIColor.white).withText("Score : \(score)").withFontHeleticaMedium(16).textCentered()
        
        nameLabel.frame = CGRect(x: 20, y: scoreLabel.frame.maxY, width: 60, height: 36)
        nameLabel.withFontHeleticaMedium(15).withText("Name :").withTextColor(UIColor.white)
        addSubviews(nameLabel)
        
        textField.frame = CGRect(x: nameLabel.frame.maxX, y: scoreLabel.frame.maxY, width: frame.size.width - 15 - nameLabel.frame.maxX, height: 36)
        textField.delegate = self
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.textColor = UIColor.white
        
        border.frame = CGRect(x: textField.frame.origin.x, y: textField.frame.maxY, width: textField.frame.size.width, height: 1)
        addSubviews(border)
        border.backgroundColor = UIColor.white
        
        hintLabel.frame = CGRect(x: 0, y: textField.frame.maxY, width: self.frame.width, height: 24)
        hintLabel.withFontHeletica(12).withText("Name must has 4 more characters").withTextColor(UIColor(fromHexString: "E0131C")).textCentered()
        
        doneBtn.frame = CGRect(x: frame.size.width / 2 - 100, y: textField.frame.maxY + 15, width: 90, height: 44)
        doneBtn.withFontHeleticaMedium(15).withTitleColor(UIColor.white).withTitle("Submit").withHighlightTitleColor(UIColor.lightGray)
        doneBtn.addTarget(self, action: #selector(doneBtnDidClicked), for: .touchUpInside)
        addSubviews(scoreLabel, textField, doneBtn)
        
        cancelBtn.frame = CGRect(x: frame.size.width / 2 + 10, y: doneBtn.frame.origin.y, width: 90, height: 44)
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidClicked), for: .touchUpInside)
        cancelBtn.withFontHeleticaMedium(15).withTitleColor(UIColor.white).withTitle("Cancel").withHighlightTitleColor(UIColor.lightGray)
        addSubviews(cancelBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setRankInfo(_ rank : Int){
        active.stopAnimating()
        rankLabel.withTextColor(UIColor.white).withText("Ranking : \(rank)")
    }
    
    func doneBtnDidClicked(){
        if checkInput(){
            textField.resignFirstResponder()
            delegate?.completeViewDidSubmit(self, name: textField.text!)
        }
    }
    
    func showAnimation(_ startFrame: CGRect) {
        let tmpSize = frame
        alpha = 0
        self.frame = startFrame
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = tmpSize
            self.alpha = 1
        })
    }
    
    func hideAnimation(_ endFrame : CGRect) {
        let tmpSize = frame
        alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = endFrame
            self.alpha = 0
            },completion: {(Bool) -> Void in
                self.removeFromSuperview()
                self.frame = tmpSize
        })
    }
    
    func checkInput() -> Bool{
        if textField.text != nil{
            textField.text = textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let cnt = ([Character](textField.text!.characters)).count
            if cnt < 4 {
                addSubviews(hintLabel)
                return false
            }
            hintLabel.removeFromSuperview()
            return true
        }else{
            addSubviews(hintLabel)
            return false
        }
    }
    
    func cancelBtnDidClicked(){
        textField.resignFirstResponder()
        delegate?.completeViewDidCancel(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if checkInput(){
            textField.resignFirstResponder()
            doneBtnDidClicked()
            return true
        }
        return false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
