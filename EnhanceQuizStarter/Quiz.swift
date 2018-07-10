//
//  Quiz.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 02/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

let numberOfQuestionsPerRound = 6
let quizMaster = QuizQuestions()
let questionSet = quizMaster.setQuestions()

class Quiz {
    let questions = questionSet
    let questionsPerRound = numberOfQuestionsPerRound
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var askedQuestionIndexes: [Int]  // To keep track of indices of questions that's already asked
    var gotChampion = false          // To flag the user who got all answers right
    
    init() {
        askedQuestionIndexes = []
    }
    
    /// Instance method to get a random question
    func getQuestion() -> Question {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        // To prevent getting the same question
        while (askedQuestionIndexes.contains(indexOfSelectedQuestion)) {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        }
        // Store the indices of questions already generated
        askedQuestionIndexes.append(indexOfSelectedQuestion)
        questionsAsked += 1
        return questions[indexOfSelectedQuestion]
    }
    
    /// Instance method to evaluate whether an answer is right or wrong
    func evaluate(answer: String, ofQuestion index: Int) -> Bool {
        if (answer == questions[index].rightAnswer.1) {
            return true
        } else {
            return false
        }
    }

    /// Instance method to play game start sound
    func playGameStartSound() {
       var sound: SystemSoundID = 0
       sound = load(sound: "GameSound", ofType: "wav")
       play(gameSound: sound)
    }
    
    /// Instance method to play correct answer sound
    func playCorrectAnswerSound() {
        var sound: SystemSoundID = 0
        sound = load(sound: "correct", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play wrong answer sound
    func playWrongAnswerSound() {
        var sound: SystemSoundID = 0
        sound = load(sound: "wrong", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play winner sound
    func playWinnerSound() {
        var sound: SystemSoundID = 0
        if gotChampion {
           sound = load(sound: "geek", ofType: "wav")
        } else {
           sound = load(sound: "winner", ofType: "wav")
        }
        play(gameSound: sound)
    }
    
    /// Instance method to play loser sound
    func playLoserSound() {
        var sound: SystemSoundID = 0
        sound = load(sound: "loser", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Instance method to play timeout sound
    func playTimeOutSound() {
        var sound: SystemSoundID = 0
        sound = load(sound: "time_over", ofType: "wav")
        play(gameSound: sound)
    }
    
    /// Helper method to load a game sound
    func load(sound: String, ofType type: String) -> SystemSoundID {
        var gameSound: SystemSoundID = 0
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
