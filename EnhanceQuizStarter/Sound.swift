//
//  Sound.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 13/08/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import AudioToolbox

class Sound {
    var sound: SystemSoundID = 0
    var gameSound: SystemSoundID = 0
    
    /// Instance method to play game start sound
    func playGameStartSound() {
        sound = load(sound: "GameSound", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play correct answer sound
    func playCorrectAnswerSound() {
        sound = load(sound: "correct", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play wrong answer sound
    func playWrongAnswerSound() {
        sound = load(sound: "wrong", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play winner sound
    func playWinnerSound(gotChampion champion: Bool) {
        if champion {
            sound = load(sound: "geek", ofType: "wav")
        } else {
            sound = load(sound: "winner", ofType: "wav")
        }
        play(gameSound: sound)
    }
    
    /// Instance method to play loser sound
    func playLoserSound() {
        sound = load(sound: "loser", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play timeout sound
    func playTimeOutSound() {
        sound = load(sound: "time_over", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Helper method to load a game sound
    func load(sound: String, ofType type: String) -> SystemSoundID {
        let path = Bundle.main.path(forResource: sound, ofType: type)
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
        return gameSound
    }
    
    /// Helper method to play a game sound
    func play(gameSound: SystemSoundID) {
        AudioServicesPlaySystemSound(gameSound)
    }
    
}
