//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//
//  Refactored existing code using OOP principles and MVC design pattern
//  and added more few more features by Abhilash Muraleedharan on 07/07/18.
//

import UIKit

let timer_value = 15

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    @IBOutlet weak var choice3Button: UIButton!
    @IBOutlet weak var choice4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    let quiz = Quiz(questions: questionsList)
    var gameTimer: Timer!
    var timerRunning: Bool = false
    var seconds_left = timer_value
    
    // MARK: - Actions
    
    @IBAction func choice1(_ sender: UIButton) {
        choice1Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect = false
        isCorrect = quiz.evaluate(answer: (choice1Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func choice2(_ sender: UIButton) {
        choice2Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect = false
        isCorrect = quiz.evaluate(answer: (choice2Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func choice3(_ sender: UIButton) {
        choice3Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect = false
        isCorrect = quiz.evaluate(answer: (choice3Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func choice4(_ sender: UIButton) {
        choice4Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect = false
        isCorrect = quiz.evaluate(answer: (choice4Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        if (playAgainButton.titleLabel?.text)! == "Play Again" {
            quiz.playGameStartSound()
        }
        nextRound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "friends.png")!)
        choice1Button.layer.borderWidth = 1.0
        choice1Button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        choice2Button.layer.borderWidth = 1.0
        choice2Button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        choice3Button.layer.borderWidth = 1.0
        choice3Button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        choice4Button.layer.borderWidth = 1.0
        choice4Button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        questionLabel.textColor = UIColor.black
        timerLabel.textColor = UIColor.black
        quiz.playGameStartSound()
        displayQuestion()
    }
    
    func announceResult(status: Bool) {
        gameTimer.invalidate()
        if status {
            quiz.correctQuestions += 1
            quiz.playCorrectAnswerSound()
            resultLabel.textColor = UIColor.blue
            resultLabel.text = "Correct!"
            resultLabel.isHidden = false
        } else {
            quiz.playWrongAnswerSound()
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Wrong! The right answer is \(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.1)"
            resultLabel.isHidden = false
        }
        switch (quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.0) {
        case 0: choice1Button.setBackgroundColor(UIColor.green, for: .normal)
        case 1: choice2Button.setBackgroundColor(UIColor.green, for: .normal)
        case 2: choice3Button.setBackgroundColor(UIColor.green, for: .normal)
        case 3: choice4Button.setBackgroundColor(UIColor.green, for: .normal)
        default:
            break;
        }
        disableButtons()
        gameTimer.invalidate()
        if quiz.questionsAsked == quiz.questionsPerRound {
            resultLabel.textColor = UIColor.white
            resultLabel.text = "Game Over!"
            displayScore()
            gameTimer.invalidate()
            quiz.askedQuestionIndexes = []
            quiz.questionsAsked = 0
            quiz.correctQuestions = 0
            quiz.gotChampion = false
        } else {
            playAgainButton.setTitle("Next Question", for: .normal)
            playAgainButton.isHidden = false
        }
    }
    
    func resetTimer() {
        seconds_left = timer_value
        timerRunning = false
    }
    
    func startTimer() {
        timerLabel.text = "\(seconds_left)"
        if !timerRunning {
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeOutHandler), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }
    
    @objc func timeOutHandler() {
        seconds_left -= 1
        timerLabel.text = "\(seconds_left)"
        if (seconds_left == 0) {
            gameTimer.invalidate()
            quiz.playTimeOutSound()
            disableButtons()
            resultLabel.text = "Sorry! Time's up. The right answer is \(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.1)"
            switch(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.0) {
            case 0: choice1Button.setBackgroundColor(UIColor.green, for: .normal)
            case 1: choice2Button.setBackgroundColor(UIColor.green, for: .normal)
            case 2: choice3Button.setBackgroundColor(UIColor.green, for: .normal)
            case 3: choice4Button.setBackgroundColor(UIColor.green, for: .normal)
            default:
            break;
            }
            playAgainButton.setTitle("Next Question", for: .normal)
            playAgainButton.isHidden = false
        }
    }
    
    
    
    func displayQuestion() {
        resultLabel.isHidden = true
        let quizQuestion = quiz.getQuestion()
        displayButtons()
        questionLabel.text = quizQuestion.question
        choice1Button.setTitle(quizQuestion.choices[0], for: .normal)
        choice2Button.setTitle(quizQuestion.choices[1], for: .normal)
        choice3Button.setTitle(quizQuestion.choices[2], for: .normal)
        if (quizQuestion.choices.count == 3) {
            choice4Button.isHidden = true
        } else {
            choice4Button.setTitle(quizQuestion.choices[3], for: .normal)
        }
        playAgainButton.isHidden = true
        resetTimer()
        if timerLabel.isHidden {
            timerLabel.isHidden = false
        }
        startTimer()
    }
    
    func displayScore() {
        
        // Hide buttons and labels
        timerLabel.isHidden = true
        hideButtons()
        
        // Display play again button
        playAgainButton.setTitle("Play Again", for: .normal)
        playAgainButton.isHidden = false
        
        // Annouce result with appropriate sound
        if (quiz.correctQuestions == quiz.questionsPerRound) {
            questionLabel.text = "Perfection! You got all right!"
            quiz.gotChampion = true
            quiz.playWinnerSound()
        } else if quiz.correctQuestions > quiz.questionsPerRound / 2 {
            questionLabel.text = "Way to go! You got \(quiz.correctQuestions) out of \(quiz.questionsPerRound) right!"
            quiz.playWinnerSound()
        } else {
            questionLabel.text = "You got only \(quiz.correctQuestions) out of \(quiz.questionsPerRound) correct!"
            quiz.playLoserSound()
        }
    }
    
    func nextRound() {
            seconds_left = timer_value
            enableButtons()
            resetButtonColors()
            displayQuestion()
    }

    func processAnswer(after seconds: Int, ofStatus status: Bool) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.announceResult(status: status)
        }
    }
    
    func enableButtons() {
        
        choice1Button.isUserInteractionEnabled = true
        choice2Button.isUserInteractionEnabled = true
        choice3Button.isUserInteractionEnabled = true
        choice4Button.isUserInteractionEnabled = true
        
    }
    
    func disableButtons() {
        
        choice1Button.isUserInteractionEnabled = false
        choice2Button.isUserInteractionEnabled = false
        choice3Button.isUserInteractionEnabled = false
        choice4Button.isUserInteractionEnabled = false
        
    }
    
    func resetButtonColors() {
        choice1Button.setBackgroundColor(UIColor(rgb: 0x0C7996), for: .normal)
        choice2Button.setBackgroundColor(UIColor(rgb: 0x0C7996), for: .normal)
        choice3Button.setBackgroundColor(UIColor(rgb: 0x0C7996), for: .normal)
        choice4Button.setBackgroundColor(UIColor(rgb: 0x0C7996), for: .normal)
    }
    
    func hideButtons() {
        choice1Button.isHidden = true
        choice2Button.isHidden = true
        choice3Button.isHidden = true
        choice4Button.isHidden = true
    }
    
    func displayButtons() {
        choice1Button.isHidden = false
        choice2Button.isHidden = false
        choice3Button.isHidden = false
        choice4Button.isHidden = false
    }
    
}

