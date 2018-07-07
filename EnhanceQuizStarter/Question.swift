//
//  Question.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 02/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

struct Question {
    var question: String
    var rightAnswer: (Int, String)  // A tuple that stores the index and the answer string
    var choices: [String]
    
    init(question: String, rightAnswer: (Int, String), choices: [String]) {
        self.question = question
        self.rightAnswer = rightAnswer
        self.choices = choices
    }
}




