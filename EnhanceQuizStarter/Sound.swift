//
//  Sound.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 13/08/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import AudioToolbox

enum GameSound: String {
    case startSound = "GameSound"
    case correctSound = "correct"
    case wrongSound = "wrong"
    case geekSound = "geek"
    case loserSound = "loser"
    case winnerSound = "winner"
    case timeOverSound = "time_over"
}

enum SoundType: String {
    case mp3
    case wav
}

enum GameSoundError: Error {
    case invalidResource(description: String)
}

class Sound {
    var sound: SystemSoundID = 0
    var gameSound: SystemSoundID = 0
    
    /// Instance method to play game sound
    func generateAudioOf(sound gameSound: GameSound, type soundType: SoundType = .wav) {
        do {
            sound = try load(sound: gameSound, ofType: soundType)
            play(gameSound: sound)
        } catch GameSoundError.invalidResource(let error) {
            fatalError("\(error)")
        } catch {
            fatalError("Unknown Error")
        }
    }
    
    func playGameStartSound() {
        generateAudioOf(sound: .startSound)
    }
    
    /// Instance method to play correct answer sound
    func playCorrectAnswerSound() {
        generateAudioOf(sound: .correctSound)
    }
    
    /// Instance method to play wrong answer sound
    func playWrongAnswerSound() {
        generateAudioOf(sound: .wrongSound)
    }
    
    /// Instance method to play winner sound
    func playWinnerSound(gotChampion champion: Bool) {
        if champion {
            generateAudioOf(sound: .geekSound)
        } else {
            generateAudioOf(sound: .winnerSound)
        }
    }
    
    /// Instance method to play loser sound
    func playLoserSound() {
        generateAudioOf(sound: .loserSound)
    }
    
    /// Instance method to play timeout sound
    func playTimeOutSound() {
        generateAudioOf(sound: .timeOverSound)
    }
    
    /// Helper method to load a game sound
    func load(sound: GameSound, ofType type: SoundType) throws -> SystemSoundID {
        guard let path = Bundle.main.path(forResource: sound.rawValue, ofType: type.rawValue) else {
            throw GameSoundError.invalidResource(description: "Missing sound file")
        }
        let soundUrl = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
        return gameSound
    }
    
    /// Helper method to play a game sound
    func play(gameSound: SystemSoundID) {
        AudioServicesPlaySystemSound(gameSound)
    }
}
