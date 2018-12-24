//
//  QuizQuestions.swift
//  EnhanceQuizStarter
//
//  Created by Abhilash Muraleedharan on 02/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

// Data Model containing the list of all F.R.I.E.N.D.S Trivia Quiz Questions
struct QuizMaster {
    let question1 = Question(question: "Which friend directed 'Since You've Been Gone'?",
                         rightAnswer: (3, "David Schwimmer"),
                         choices: ["Matt LeBlanc", "Matthew Perry", "Jennifer Aniston", "David Schwimmer"])
    let question2 = Question(question: "Who was Ross's second wife?",
                         rightAnswer: (1, "Emily"),
                         choices: ["Julie", "Emily", "Bonnie"])
    let question3 = Question(question: "Who plays Chandler?",
                         rightAnswer: (3, "Matthew Perry"),
                         choices: ["David Schwimmer", "Joshua Jackson", "Matt LeBlanc", "Matthew Perry"])
    let question4 = Question(question: "Who was Rachel going to marry but left at the altar?",
                         rightAnswer: (0, "Barry Farber"),
                         choices: ["Barry Farber", "Tag Jones", "Joey Tribbiani"])
    let question5 = Question(question: "What is the name of Ross's son?",
                         rightAnswer: (1, "Ben"),
                         choices: ["Daniel", "Ben", "Carl"])
    let question6 = Question(question: "Whose favourite food is sandwiches?",
                         rightAnswer: (1, "Joey"),
                         choices: ["Ross", "Joey", "Chandler"])
    let question7 = Question(question: "Which character got hit by a tranquilizer dart?",
                         rightAnswer: (0, "Phoebe"),
                         choices: ["Phoebe", "Rachel", "Monica", "Janice"])
    let question8 = Question(question: "Who does Phoebe end up getting married to?",
                         rightAnswer: (2, "Mike"),
                         choices: ["David", "Eric", "Mike", "Ryan"])
    let question9 = Question(question: "Ross was which of these?",
                         rightAnswer: (2, "Doctor"),
                         choices: ["Lawyer", "Accountant", "Doctor"])
    let question10 = Question(question: "At the end of the series Rachel is offered a job in which city?",
                          rightAnswer: (1, "Paris"),
                          choices: ["New York", "Paris", "Sydney", "London"])
    
    /// Instance method to return an array of quiz questions
    func setQuestions() -> [Question] {
        return [question1,question2,question3,question4,question5,question6,question7,question8,question9,question10]
    }
}



