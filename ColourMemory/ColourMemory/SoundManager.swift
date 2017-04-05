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
    fileprivate let coinSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "lock", ofType: "mp3")!)
    fileprivate let successSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "success", ofType: "wav")!)
    fileprivate let failedSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "failed", ofType: "mp3")!)
    
    var flipSound : AVAudioPlayer?
    var successSound : AVAudioPlayer?
    var failedSound : AVAudioPlayer?

    static let sharedInstance = SoundManager()
    
    override init() {
        super.init()
        
        do {
            flipSound = try AVAudioPlayer(contentsOf: coinSoundURL)
            flipSound!.prepareToPlay()
            
            successSound = try AVAudioPlayer(contentsOf: successSoundURL)
            successSound!.prepareToPlay()
            
            failedSound = try AVAudioPlayer(contentsOf: failedSoundURL)
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
