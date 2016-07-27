//
//  SoundManager.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class SoundManager: NSObject {
    private let coinSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lock", ofType: "mp3")!)
    private let successSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("success", ofType: "mp3")!)
    private let failedSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("failed", ofType: "mp3")!)
    
    var flipSound : AVAudioPlayer?
    var successSound : AVAudioPlayer?
    var failedSound : AVAudioPlayer?

    static let sharedInstance = SoundManager()
    
    override init() {
        super.init()
        
        do {
            flipSound = try AVAudioPlayer(contentsOfURL: coinSoundURL)
            flipSound!.prepareToPlay()
            
            successSound = try AVAudioPlayer(contentsOfURL: successSoundURL)
            successSound!.prepareToPlay()
            
            failedSound = try AVAudioPlayer(contentsOfURL: failedSoundURL)
            failedSound!.prepareToPlay()
        } catch {
            // couldn't load file :(
        }

    }
    
    func playFlipSound(){
        if flipSound != nil {
            flipSound!.play()
        }
    }
    
    func playSuccessSound(){
        if successSound != nil {
            successSound!.play()
        }
    }
    
    func playFailedSound(){
        if failedSound != nil {
            failedSound!.play()
        }
    }
}
