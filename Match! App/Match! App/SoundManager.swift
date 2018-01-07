//
//  SoundManager.swift
//  Match! App
//
//  Created by Tassia Paschoal on 1/7/18.
//  Copyright © 2018 Tassia Paschoal. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    static func playSound(_ effect:SoundEffect){
        
        //determine which sound effect we want to play and set the appropriate file name
        var soundFilename = ""
        
        switch effect {
         
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"

        }
        
        //get the path the sound file in the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
        
        //create url object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            //create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            //Couldn't create audio player object
            print("Couldn't create the audio palyer object for sound file \(soundFilename)")
        }
        
    }
    
}
