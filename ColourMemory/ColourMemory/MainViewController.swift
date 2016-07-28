//
//  ViewController.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

var scoreWindow : HighScoreWindow = {
    let swindow = HighScoreWindow(frame :UIScreen.mainScreen().bounds)
    swindow.rootViewController = HighScoreViewController()
    return swindow
}()

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
    
    var replayBtn = UIButton()
    var cardView : ColourCollectionView!
    
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
        
        cardView = ColourCollectionView(frame : CGRectMake(0, 64 + spacing, view.frame.size.width, height))
        cardView.delegate = self
        view.addSubview(cardView)
        
        let replayHeight : CGFloat = 100 * 168 / 148
        replayBtn.frame = CGRectMake(view.frame.size.width / 2 - 50, cardView.frame.height / 2 + cardView.frame.origin.y - 25 - replayHeight / 2, 100, replayHeight)
        replayBtn.withImage(UIImage(named: "ReplayIcon"))
        replayBtn.addTarget(self, action: #selector(replayBtnDidClicked), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func replayBtnDidClicked(){
        UIView.animateWithDuration(1, animations:{
            self.replayBtn.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.replayBtn.alpha = 0
        })
        
        let complete = {() -> Void in
            self.replayBtn.layer.removeAllAnimations()
            self.replayBtn.removeFromSuperview()
            self.replayBtn.transform = CGAffineTransformIdentity
            self.replayBtn.alpha = 1
        }
        currentScore = 0
        cardView.restartAnimation(completion: complete)
    }
    
    func highScoreDidClicked(){
        scoreWindow.makeKeyAndVisible()
        
        scoreWindow.showAnimation({(Bool) -> Void in
            if let vc = scoreWindow.rootViewController{
                if let svc = vc as? HighScoreViewController {
                    svc.reloadHighScore()
                }
            }
        })
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
        reminderLabel.frame = CGRectMake(scoreLabel.frame.origin.x, 300, scoreLabel.frame.size.width, 44)
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
        let completeView = CompleteView(frame: CGRectMake(self.view.frame.size.width / 2 - 150, self.view.frame.size.height / 2 - 181 / 2 - 25, 300, 181), score: self.currentScore)
        completeView.delegate = self
        
        let handler = {(rank : Int) -> Void in
            completeView.setRankInfo(rank)
        }
        DataContainer.sharedIntance.getRanking(self.currentScore, handler: handler)
        self.view.addSubviews(completeView)
        completeView.showAnimation(highScoreBtn.frame)
    }
    
    func showReplayBtn(){
        self.replayBtn.alpha = 0
        view.addSubview(replayBtn)
        UIView.animateWithDuration(0.3, animations: {
            self.replayBtn.alpha = 1
            }, completion: nil)
    }
    
    func completeViewDidCancel(completeView: CompleteView) {
        completeView.hideAnimation(completeView.frame)
        showReplayBtn()
    }
    
    func completeViewDidSubmit(completeView: CompleteView, name: String) {
        completeView.hideAnimation(highScoreBtn.frame)
        DataContainer.sharedIntance.storeScore(self.currentScore, name: name)
        showReplayBtn()
    }
    
    func colourCollectionViewMemoryFailed(colourView: ColourCollectionView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.showReminderLabel(-1)
            SoundManager.sharedInstance.playFailedSound()
            colourView.recoverFlippedCard()
        }
    }
    
    func colourCollectionViewMemorySuccess(colourView: ColourCollectionView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.showReminderLabel(2)
            SoundManager.sharedInstance.playSuccessSound()
            colourView.destroyFlippedCard()
        }
    }
    
    func colourCollectionViewMemoryComplete(colourView: ColourCollectionView) {
        self.showCompleteView()
    }
}
