//
//  CompleteView.swift
//  ColourMemory
//
//  Created by jiao qing on 26/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

protocol CompleteViewDelegate : NSObjectProtocol{
    func completeViewDidSubmit(completeView: CompleteView, name : String)
    func completeViewDidCancel(completeView: CompleteView)
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
    
    init(frame: CGRect, score : Int) {
        super.init(frame : frame)
        
        clipsToBounds = true
        backgroundColor = UIColor(fromHexString: "0F0E14")
        
        rankLabel.frame = CGRectMake(0, 10, frame.size.width, 36)
        rankLabel.withFontHeleticaMedium(16).textCentered()
        addSubviews(rankLabel)
        
        scoreLabel.frame = CGRectMake(0, CGRectGetMaxY(rankLabel.frame), frame.size.width, 36)
        scoreLabel.withTextColor(UIColor.whiteColor()).withText("Score : \(score)").withFontHeleticaMedium(16).textCentered()
        
        nameLabel.frame = CGRectMake(20, CGRectGetMaxY(scoreLabel.frame), 60, 36)
        nameLabel.withFontHeleticaMedium(15).withText("Name :").withTextColor(UIColor.whiteColor())
        addSubviews(nameLabel)
        
        textField.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMaxY(scoreLabel.frame), 100, 36)
        textField.delegate = self
        textField.textAlignment = .Center
        textField.returnKeyType = .Done
        textField.textColor = UIColor.whiteColor()
        
        border.frame = CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), textField.frame.size.width, 1)
        addSubviews(border)
        border.backgroundColor = UIColor.whiteColor()
        
        hintLabel.frame = CGRectMake(0, CGRectGetMaxY(textField.frame), self.frame.width, 24)
        hintLabel.withFontHeletica(12).withText("Name must has 4 more characters").withTextColor(UIColor(fromHexString: "E0131C")).textCentered()
        
        doneBtn.frame = CGRectMake(frame.size.width / 2 - 100, CGRectGetMaxY(textField.frame) + 15, 90, 44)
        doneBtn.withFontHeleticaMedium(15).withTitleColor(UIColor.whiteColor()).withTitle("Submit").withHighlightTitleColor(UIColor.lightGrayColor())
        doneBtn.addTarget(self, action: #selector(doneBtnDidClicked), forControlEvents: .TouchUpInside)
        addSubviews(scoreLabel, textField, doneBtn)
        
        cancelBtn.frame = CGRectMake(frame.size.width / 2 + 10, doneBtn.frame.origin.y, 90, 44)
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidClicked), forControlEvents: .TouchUpInside)
        cancelBtn.withFontHeleticaMedium(15).withTitleColor(UIColor.whiteColor()).withTitle("Cancel").withHighlightTitleColor(UIColor.lightGrayColor())
        addSubviews(cancelBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setRankInfo(rank : Int){
        rankLabel.withTextColor(UIColor.whiteColor()).withText("Ranking : \(rank)")
    }
    
    func doneBtnDidClicked(){
        if checkInput(){
            textField.resignFirstResponder()
            delegate?.completeViewDidSubmit(self, name: textField.text!)
        }
    }
    
    func showAnimation(startFrame: CGRect) {
        let tmpSize = frame
        alpha = 0
        self.frame = startFrame
        UIView.animateWithDuration(0.5, animations: {
            self.frame = tmpSize
            self.alpha = 1
        })
    }
    
    func hideAnimation(endFrame : CGRect) {
        let tmpSize = frame
        alpha = 1
        UIView.animateWithDuration(0.3, animations: {
            self.frame = endFrame
            self.alpha = 0
            },completion: {(Bool) -> Void in
                self.removeFromSuperview()
                self.frame = tmpSize
        })
    }
    
    func checkInput() -> Bool{
        if textField.text != nil{
            textField.text = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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