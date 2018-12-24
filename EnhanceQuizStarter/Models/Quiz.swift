//
//  Quiz.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 02/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import GameKit

struct Quiz {
    let quizMaster = QuizMaster()
    var soundGenerator = QuizSoundGenerator()
    let questions: [Question]
    let questionsPerRound = 6
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var askedQuestionsIndices = [Int]()  // To keep track of indices of questions that are already asked
    var lightningRoundTimer: Timer!
    var isTimerRunning = false
    var lightningRoundDuration = 15
    
    init() {
        questions = quizMaster.setQuestions()
    }
    
    /// Instance method to get a random question
    mutating func getQuestion() -> Question {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        // To prevent getting the same question
        while (askedQuestionsIndices.contains(indexOfSelectedQuestion)) {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        }
        // Store the indices of questions already generated
        askedQuestionsIndices.append(indexOfSelectedQuestion)
        questionsAsked += 1
        return questions[indexOfSelectedQuestion]
    }
    
    /// Instance method to evaluate whether an answer is right or wrong
    func evaluate(answer: String, ofQuestion index: Int) -> Bool {
        return answer == questions[index].rightAnswer.value ? true : false
    }
}
