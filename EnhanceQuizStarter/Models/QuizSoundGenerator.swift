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

struct QuizSoundGenerator {
    var gameSound: SystemSoundID = 0
    
    /// Instance method to play game sound
    mutating func generateAudioOf(_ gameSound: GameSound, type soundType: SoundType = .wav) {
        do {
            try load(sound: gameSound, ofType: soundType)
            play(self.gameSound)
        } catch GameSoundError.invalidResource(let error) {
            fatalError("\(error)")
        } catch {
            fatalError("Unknown Error")
        }
    }
    
    mutating func playGameStartSound() {
        generateAudioOf(.startSound)
    }
    
    /// Instance method to play correct answer sound
    mutating func playCorrectAnswerSound() {
        generateAudioOf(.correctSound)
    }
    
    /// Instance method to play wrong answer sound
    mutating func playWrongAnswerSound() {
        generateAudioOf(.wrongSound)
    }
    
    /// Instance method to play winner sound
    mutating func playWinnerSound(gotChampion champion: Bool) {
        if champion {
            generateAudioOf(.geekSound)
        } else {
            generateAudioOf(.winnerSound)
        }
    }
    
    /// Instance method to play loser sound
    mutating func playLoserSound() {
        generateAudioOf(.loserSound)
    }
    
    /// Instance method to play timeout sound
    mutating func playTimeOutSound() {
        generateAudioOf(.timeOverSound)
    }
    
    /// Helper method to load a game sound
    mutating func load(sound: GameSound, ofType type: SoundType) throws {
        guard let path = Bundle.main.path(forResource: sound.rawValue, ofType: type.rawValue) else {
            throw GameSoundError.invalidResource(description: "Missing sound file")
        }
        let soundUrl = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    /// Helper method to play a game sound
    func play(_ gameSound: SystemSoundID) {
        AudioServicesPlaySystemSound(gameSound)
    }
}
