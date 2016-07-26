//
//  ViewController.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let scoreLabel = UILabel()
    let reminderLabel = UILabel()
    let highScoreBtn = UIButton()
    
    private var _currentScore = 0
    var currentScore : Int {
        set {
            _currentScore = newValue
            scoreLabel.withText("Score: \(_currentScore)")
        }
        get { return _currentScore }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black24()
        
        let logoIV = UIImageView(frame : CGRectMake(0, 20, 120, 44))
        logoIV.contentMode = .ScaleAspectFit
        logoIV.image = UIImage(named: "LogoIcon")
        view.addSubview(logoIV)
        
        scoreLabel.frame = CGRectMake(view.frame.size.width / 2 - 80, 20, 160, 44)
        view.addSubview(scoreLabel)
        scoreLabel.withTextColor(UIColor.whiteColor()).textCentered()
        currentScore = 0
        
        highScoreBtn.frame = CGRectMake(view.frame.size.width - 23 - 85, 20, 90, 44)
        view.addSubview(highScoreBtn)
        highScoreBtn.withFontHeleticaMedium(16).withTitle("High Scores").withTitleColor(UIColor.whiteColor())
        highScoreBtn.addTarget(self, action: #selector(highScoreDidClicked), forControlEvents: .TouchUpInside)
        
        let height = (view.frame.size.width - 15) * 190 / 152 + 15
        let spacing = (view.frame.size.height - height - 64) / 2
        
        let cardView = ColourCollectionView(frame : CGRectMake(0, 64 + spacing, view.frame.size.width, height))
        cardView.delegate = self
        view.addSubview(cardView)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func highScoreDidClicked(){
        
    }
    
    func showReminderLabel(getScore : Int){
        reminderLabel.textCentered().withFontHeleticaMedium(18)
        if getScore >= 0 {
            reminderLabel.withText("+\(getScore)")
            reminderLabel.withTextColor(UIColor.whiteColor())
        }else{
            reminderLabel.withText("\(getScore)")
            reminderLabel.withTextColor(UIColor(fromHexString: "E0131C"))
        }
        view.addSubview(reminderLabel)
        reminderLabel.alpha = 1
        reminderLabel.frame = CGRectMake(view.frame.size.width / 2 - 50, 300, 100, 44)
        let scoreFrame = self.scoreLabel.frame
        UIView.animateWithDuration(1, animations: {
            self.reminderLabel.alpha = 1
            self.reminderLabel.frame = CGRectMake(scoreFrame.origin.x, scoreFrame.origin.y + 25, scoreFrame.size.width, scoreFrame.size.height)
            }, completion: {(Bool) -> Void in
                self.reminderLabel.removeFromSuperview()
                self.currentScore += getScore
            })
    }
}

extension MainViewController: ColourCollectionViewDelegate, CompleteViewDelegate {
    func showCompleteView(){
        let completeView = CompleteView(frame: CGRectMake(self.view.frame.size.width / 2 - 110, self.view.frame.size.height / 2 - 135 / 2 - 25, 220, 145), score: self.currentScore)
        completeView.delegate = self
        self.view.addSubviews(completeView)
        completeView.showAnimation(highScoreBtn.frame)
    }
    
    func completeViewDidCancel(completeView: CompleteView) {
        completeView.hideAnimation(completeView.frame)
    }
    
    func completeViewDidSubmit(completeView: CompleteView, name: String) {
        completeView.hideAnimation(highScoreBtn.frame)
        DataContainer.sharedIntance.storeScore(self.currentScore, name: name)
    }
    
    func colourCollectionViewMemoryFailed(colourView: ColourCollectionView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.showReminderLabel(-1)
            colourView.recoverFlippedCard()
        }
    }
    
    func colourCollectionViewMemorySuccess(colourView: ColourCollectionView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.showReminderLabel(2)
            colourView.destroyFlippedCard()
        }
    }
    
    func colourCollectionViewMemoryComplete(colourView: ColourCollectionView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.showCompleteView()
        }
    }
}
