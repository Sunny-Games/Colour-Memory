//
//  ViewController.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SnapKit


var scoreWindow : HighScoreWindow = {
  let swindow = HighScoreWindow(frame :UIScreen.main.bounds)
  swindow.rootViewController = HighScoreViewController()
  return swindow
}()

let successGain = 25
let failedGain = -20

class MainViewController: UIViewController {
  let scoreLabel = UILabel()
  let reminderLabel = UILabel()
  let highScoreBtn = UIButton()
  
  fileprivate var _currentScore = 0
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
    
    let logoIV = UIImageView(frame : CGRect(x: 0, y: 20, width: 120, height: 44))
    logoIV.contentMode = .scaleAspectFit
    logoIV.image = UIImage(named: "LogoIcon")
    view.addSubview(logoIV)
    
    view.addSubview(scoreLabel)
    scoreLabel.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(logoIV)
    }
    scoreLabel.withTextColor(UIColor.white)
    currentScore = 0
    
    view.addSubview(highScoreBtn)
    highScoreBtn.snp.makeConstraints { make in
      make.centerY.equalTo(logoIV)
      make.width.equalTo(90)
      make.height.equalTo(44)
      make.trailing.equalTo(view).offset(-20)
    }
    highScoreBtn.withFontHeleticaMedium(16).withTitle("High Scores").withTitleColor(UIColor.white)
    highScoreBtn.addTarget(self, action: #selector(highScoreDidClicked), for: .touchUpInside)
    
    cardView = ColourCollectionView()
    cardView.delegate = self
    view.addSubview(cardView)
    cardView.snp.makeConstraints { make in
      make.leading.equalTo(view)
      make.width.equalTo(view)
      make.centerY.equalTo(view)
    }
    
    replayBtn.withImage(UIImage(named: "ReplayIcon"))
    replayBtn.addTarget(self, action: #selector(replayBtnDidClicked), for: .touchUpInside)
    replayBtn.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.width.equalTo(100)
      make.height.equalTo(100 * 168 / 148)
      make.centerY.equalTo(view)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  func replayBtnDidClicked(){
    UIView.animate(withDuration: 1, animations:{
      self.replayBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
      self.replayBtn.alpha = 0
    })
    
    let complete = {() -> Void in
      self.replayBtn.layer.removeAllAnimations()
      self.replayBtn.removeFromSuperview()
      self.replayBtn.transform = CGAffineTransform.identity
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
  
  func showReminderLabel(_ getScore : Int){
    reminderLabel.textCentered().withFontHeleticaMedium(18)
    if getScore >= 0 {
      reminderLabel.withText("+\(getScore)")
      reminderLabel.withTextColor(UIColor.white)
    }else{
      reminderLabel.withText("\(getScore)")
      reminderLabel.withTextColor(UIColor(fromHexString: "E0131C"))
    }
    view.addSubview(reminderLabel)
    reminderLabel.alpha = 1
    reminderLabel.frame = CGRect(x: scoreLabel.frame.origin.x, y: 300, width: scoreLabel.frame.size.width, height: 44)
    let scoreFrame = self.scoreLabel.frame
    UIView.animate(withDuration: 1, animations: {
      self.reminderLabel.alpha = 1
      self.reminderLabel.frame = CGRect(x: scoreFrame.origin.x, y: scoreFrame.origin.y + 25, width: scoreFrame.size.width, height: scoreFrame.size.height)
    }, completion: {(Bool) -> Void in
      self.reminderLabel.removeFromSuperview()
      self.currentScore += getScore
    })
  }
}

extension MainViewController: ColourCollectionViewDelegate, CompleteViewDelegate {
  func showCompleteView(){
    let completeView = CompleteView(frame: CGRect.zero, score: self.currentScore)
    completeView.delegate = self
    completeView.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.width.equalTo(300)
      make.height.equalTo(181)
      make.centerY.equalTo(view).offset(-25)
    }
    
    let handler = {(rank : Int) -> Void in
      completeView.setRankInfo(rank)
    }
    completeView.textField.becomeFirstResponder()
    DataContainer.sharedIntance.getRanking(self.currentScore, handler: handler)
    self.view.addSubviews(completeView)
    completeView.showAnimation(highScoreBtn.frame)
  }
  
  func showReplayBtn(){
    self.replayBtn.alpha = 0
    view.addSubview(replayBtn)
    UIView.animate(withDuration: 0.3, animations: {
      self.replayBtn.alpha = 1
    }, completion: nil)
  }
  
  func completeViewDidCancel(_ completeView: CompleteView) {
    completeView.hideAnimation(completeView.frame)
    showReplayBtn()
  }
  
  func completeViewDidSubmit(_ completeView: CompleteView, name: String) {
    completeView.hideAnimation(highScoreBtn.frame)
    DataContainer.sharedIntance.storeScore(self.currentScore, name: name)
    showReplayBtn()
  }
  
  func colourCollectionViewMemoryFailed(_ colourView: ColourCollectionView) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
      self.showReminderLabel(failedGain)
      SoundManager.sharedInstance.playFailedSound()
      colourView.recoverFlippedCard()
    }
  }
  
  func colourCollectionViewMemorySuccess(_ colourView: ColourCollectionView) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
      self.showReminderLabel(successGain)
      SoundManager.sharedInstance.playSuccessSound()
      colourView.destroyFlippedCard()
    }
  }
  
  func colourCollectionViewMemoryComplete(_ colourView: ColourCollectionView) {
    self.showCompleteView()
  }
}
