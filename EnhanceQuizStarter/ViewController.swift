//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//
//  Refactored existing code using OOP principles and MVC design pattern
//  and added few more features as per project requirement.
//  By Abhilash Muraleedharan on 07/07/18.
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
    @IBOutlet weak var progressLabel: UILabel!
    
    // Declaring necessary stored properties
    let quiz = Quiz(questions: questionsList)
    var gameTimer: Timer!  // create a property of the type Timer!
    var timerRunning: Bool = false
    var seconds_left = timer_value
    
    // MARK: - Actions
    @IBAction func choice1(_ sender: UIButton) {
        // Set background to a different color to indicate the option chosen
        choice1Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect: Bool
        // Evaluate the chosen answer
        isCorrect = quiz.evaluate(answer: (choice1Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        // Add a 1 second delay before displaying the result
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func choice2(_ sender: UIButton) {
        choice2Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect: Bool
        isCorrect = quiz.evaluate(answer: (choice2Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func choice3(_ sender: UIButton) {
        choice3Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect: Bool
        isCorrect = quiz.evaluate(answer: (choice3Button.titleLabel?.text)!, ofQuestion: quiz.indexOfSelectedQuestion)
        processAnswer(after: 1, ofStatus: isCorrect)
    }
    
    @IBAction func choice4(_ sender: UIButton) {
        choice4Button.setBackgroundColor(UIColor.orange, for: .normal)
        var isCorrect: Bool
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
        progressLabel.textColor = UIColor.brown
        timerLabel.textColor = UIColor.brown
        quiz.playGameStartSound()
        displayQuestion()
    }
    
    /// Instance method to display the status of an answer to a question
    func announceResult(status: Bool) {
        // Invalidate the timer
        gameTimer.invalidate()
        if status {
            quiz.correctQuestions += 1
            quiz.playCorrectAnswerSound()
            resultLabel.textColor = UIColor.cyan
            resultLabel.text = "Correct!"
            resultLabel.isHidden = false
        } else {
            quiz.playWrongAnswerSound()
            resultLabel.textColor = UIColor.yellow
            resultLabel.text = "Wrong! The right answer is \(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.1)"
            resultLabel.isHidden = false
        }
        // To highlight the right answer
        switch (quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.0) {
        case 0: choice1Button.setBackgroundColor(UIColor.green, for: .normal)
        case 1: choice2Button.setBackgroundColor(UIColor.green, for: .normal)
        case 2: choice3Button.setBackgroundColor(UIColor.green, for: .normal)
        case 3: choice4Button.setBackgroundColor(UIColor.green, for: .normal)
        default:
            break;
        }
        gameTimer.invalidate()
        checkStatus(after: 2)  // Check quiz progress and score status after 2 seconds
    }
    
    /// Helper method to reset the timer value
    func resetTimer() {
        seconds_left = timer_value
        timerRunning = false
    }
    
    /// Helper method to start a timer
    func startTimer() {
        timerLabel.text = "\(seconds_left)"
        if !timerRunning {
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeOutHandler), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }
    
    /// Timer Event Handler
    @objc func timeOutHandler() {
        seconds_left -= 1
        timerLabel.text = "\(seconds_left)"
        if (seconds_left == 0) {
            gameTimer.invalidate()
            quiz.playTimeOutSound()
            resultLabel.textColor = UIColor.yellow
            resultLabel.text = "Sorry! Time's up. The right answer is \(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.1)"
            resultLabel.isHidden = false
            // Highlight the right answer
            switch(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.0) {
            case 0: choice1Button.setBackgroundColor(UIColor.green, for: .normal)
            case 1: choice2Button.setBackgroundColor(UIColor.green, for: .normal)
            case 2: choice3Button.setBackgroundColor(UIColor.green, for: .normal)
            case 3: choice4Button.setBackgroundColor(UIColor.green, for: .normal)
            default:
            break;
            }
            checkStatus(after: 2) // Check quiz progress and score status after 2 seconds
        }
    }
    
    /// Helper method to display a question on the screen
    func displayQuestion() {
        resultLabel.isHidden = true
        let quizQuestion = quiz.getQuestion()
        displayButtons()
        progressLabel.text = "\(quiz.questionsAsked)/\(quiz.questionsPerRound)"
        if progressLabel.isHidden {
            progressLabel.isHidden = false
        }
        questionLabel.text = quizQuestion.question
        choice1Button.setTitle(quizQuestion.choices[0], for: .normal)
        choice2Button.setTitle(quizQuestion.choices[1], for: .normal)
        choice3Button.setTitle(quizQuestion.choices[2], for: .normal)
        // Show option4 button only if 4 options are present
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
    
    /// Helper method to display the final quiz score
    func displayScore() {
        
        // Hide buttons and labels
        timerLabel.isHidden = true
        progressLabel.isHidden = true
        hideButtons()
        
        // Display play again button
        playAgainButton.setTitle("Play Again", for: .normal)
        playAgainButton.isHidden = false
        
        // Annouce result with appropriate sound
        if (quiz.correctQuestions == quiz.questionsPerRound) {
            questionLabel.text = "Perfection! You got \(quiz.correctQuestions) out of \(quiz.questionsPerRound)!"
            quiz.gotChampion = true
            quiz.playWinnerSound()
        } else if quiz.correctQuestions > quiz.questionsPerRound / 2 {
            questionLabel.text = "Awesome! You got \(quiz.correctQuestions) out of \(quiz.questionsPerRound) right!"
            quiz.playWinnerSound()
        } else {
            questionLabel.text = "You got only \(quiz.correctQuestions) out of \(quiz.questionsPerRound) correct! Try Again?"
            quiz.playLoserSound()
        }
    }
    
    /// Helper method that gives next round of questions
    func nextRound() {
            seconds_left = timer_value
            activateButtons()
            displayQuestion()
    }

    /// Helper method to inrtouduce some delay before announcing result of a question
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
    
    /// Helper method to introduce some delay before checking the quiz status
    func checkStatus(after seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.checkStatus()
        }
    }
    
    /// Helper method to activate buttons
    func activateButtons() {
        choice1Button.isUserInteractionEnabled = true
        choice2Button.isUserInteractionEnabled = true
        choice3Button.isUserInteractionEnabled = true
        choice4Button.isUserInteractionEnabled = true
        // Set font and tint color of buttons to reflect the re-activated state
        choice1Button.tintColor = UIColor.white
        choice2Button.tintColor = UIColor.white
        choice3Button.tintColor = UIColor.white
        choice4Button.tintColor = UIColor.white
        resetButtonColors()
    }
    
    /// Helper method to deactivate buttons
    func deactivateButtons() {
        choice1Button.isUserInteractionEnabled = false
        choice2Button.isUserInteractionEnabled = false
        choice3Button.isUserInteractionEnabled = false
        choice4Button.isUserInteractionEnabled = false
        // Set font and tint color of buttons to reflect the deactivated state
        choice1Button.tintColor = UIColor.lightGray
        choice2Button.tintColor = UIColor.lightGray
        choice3Button.tintColor = UIColor.lightGray
        choice4Button.tintColor = UIColor.lightGray
        resetButtonColors()
    }
    
    /// Helper method to reset highlighted button colors back to it's original color
    func resetButtonColors() {
        choice1Button.setBackgroundColor(UIColor(rgb: 0x7B7D96), for: .normal)
        choice2Button.setBackgroundColor(UIColor(rgb: 0x7B7D96), for: .normal)
        choice3Button.setBackgroundColor(UIColor(rgb: 0x7B7D96), for: .normal)
        choice4Button.setBackgroundColor(UIColor(rgb: 0x7B7D96), for: .normal)
    }
    
    /// Helper method to hide buttons
    func hideButtons() {
        choice1Button.isHidden = true
        choice2Button.isHidden = true
        choice3Button.isHidden = true
        choice4Button.isHidden = true
    }
    
    /// Helper method to show buttons
    func displayButtons() {
        choice1Button.isHidden = false
        choice2Button.isHidden = false
        choice3Button.isHidden = false
        choice4Button.isHidden = false
    }
    
    /// Instance method to check the quiz status
    func checkStatus() {
        deactivateButtons()  // To prevent user from triggering any unwanted action
        resultLabel.isHidden = true
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
}

