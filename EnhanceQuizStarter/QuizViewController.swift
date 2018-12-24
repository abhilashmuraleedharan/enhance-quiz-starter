//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//
//  Refactored existing code using OOP principles and MVC design pattern
//  and enhanced the quiz app adhering to project requirements.
//  By Abhilash Muraleedharan on 07/07/18.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    @IBOutlet weak var choice3Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - Stored properties
    var quiz = Quiz()
    var gameTimer: Timer!
    var timerRunning = false
    var secondsLeft = 15
    lazy var choice4Button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        //Set a frame for the button.
        button.frame = CGRect(x: 40, y: 422, width: 334, height: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(UIColor(rgb: 0x7B7D96), for: .normal)
        //State dependent properties title and title color
        button.setTitle("Choice 4", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(self.choice4ButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    @IBAction func choice1ButtonTapped(_ sender: UIButton) {
        // Set background to a different color to indicate the option chosen
        choice1Button.setBackgroundColor(UIColor.red, for: .normal)
        
        // Evaluate the chosen answer
        if let chosenAnswer = choice1Button.titleLabel?.text {
            let status = quiz.evaluate(answer: chosenAnswer, ofQuestion: quiz.indexOfSelectedQuestion)
            announceResult(status)
        }
    }
    
    @IBAction func choice2ButtonTapped(_ sender: UIButton) {
        choice2Button.setBackgroundColor(UIColor.red, for: .normal)
        
        if let chosenAnswer = choice2Button.titleLabel?.text {
            let status = quiz.evaluate(answer: chosenAnswer, ofQuestion: quiz.indexOfSelectedQuestion)
            announceResult(status)
        }
    }
    
    @IBAction func choice3ButtonTapped(_ sender: UIButton) {
        choice3Button.setBackgroundColor(UIColor.red, for: .normal)
        
        if let chosenAnswer = choice3Button.titleLabel?.text {
            let status = quiz.evaluate(answer: chosenAnswer, ofQuestion: quiz.indexOfSelectedQuestion)
            announceResult(status)
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        if let buttonTitle = playAgainButton.titleLabel?.text {
            if buttonTitle == "Play Again" {
                quiz.soundGenerator.playGameStartSound()
            }
        }
        loadNextRound()
    }
    
    /// choice4 button target action method
    @objc func choice4ButtonTapped(_ sender: UIButton) {
        sender.setBackgroundColor(UIColor.red, for: .normal)
        
        if let chosenAnswer = sender.titleLabel?.text {
            let status = quiz.evaluate(answer: chosenAnswer, ofQuestion: quiz.indexOfSelectedQuestion)
            announceResult(status)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "friends.png") {
            view.backgroundColor = UIColor(patternImage: image)
        }
        progressLabel.textColor = UIColor.brown
        timerLabel.textColor = UIColor.brown
        quiz.soundGenerator.playGameStartSound()
        displayQuestion()
    }

    /// Instance method to display the status of an answer to a question
    func announceResult(_ status: Bool) {
        // Invalidate the timer
        gameTimer.invalidate()
        if status {
            quiz.correctQuestions += 1
            quiz.soundGenerator.playCorrectAnswerSound()
            resultLabel.textColor = UIColor.cyan
            resultLabel.text = "Correct!"
        } else {
            quiz.soundGenerator.playWrongAnswerSound()
            resultLabel.textColor = UIColor.yellow
            resultLabel.text = "Wrong! The right answer is \(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.value)"
        }
        resultLabel.isHidden = false
        // To highlight the right answer
        switch (quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.index) {
        case 0: choice1Button.setBackgroundColor(UIColor.green, for: .normal)
        case 1: choice2Button.setBackgroundColor(UIColor.green, for: .normal)
        case 2: choice3Button.setBackgroundColor(UIColor.green, for: .normal)
        case 3: choice4Button.setBackgroundColor(UIColor.green, for: .normal)
        default:
        break;
        }
        deactivateButtons()  // To prevent user from triggering any unwanted action
        checkStatus(after: 2)  // Check quiz progress and score status after 2 seconds
    }
    
    /// Helper method to reset the timer value
    func resetTimer() {
        secondsLeft = 15
        timerRunning = false
    }
    
    /// Helper method to start a timer
    func startTimer() {
        timerLabel.text = "\(secondsLeft)"
        if !timerRunning {
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeOutHandler), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }
    
    /// Timer Event Handler
    @objc func timeOutHandler() {
        secondsLeft -= 1
        timerLabel.text = "\(secondsLeft)"
        if (secondsLeft == 0) {
            gameTimer.invalidate()
            quiz.soundGenerator.playTimeOutSound()
            resultLabel.textColor = UIColor.yellow
            resultLabel.text = "Sorry! Time's up. The right answer is \(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.value)"
            resultLabel.isHidden = false
            // Highlight the right answer
            switch(quiz.questions[quiz.indexOfSelectedQuestion].rightAnswer.index) {
            case 0: choice1Button.setBackgroundColor(UIColor.green, for: .normal)
            case 1: choice2Button.setBackgroundColor(UIColor.green, for: .normal)
            case 2: choice3Button.setBackgroundColor(UIColor.green, for: .normal)
            case 3: choice4Button.setBackgroundColor(UIColor.green, for: .normal)
            default:
            break;
            }
            deactivateButtons()  // To prevent user from triggering any unwanted action
            checkStatus(after: 2) // Check quiz progress and score status after 2 seconds
        }
    }
    
    /// Helper method to display a question on the screen
    func displayQuestion() {
        resultLabel.isHidden = true
        let quizQuestion = quiz.getQuestion()
        displayButtons()
        progressLabel.text = "\(quiz.questionsAsked)/\(quiz.questionsPerRound)"
        progressLabel.isHidden = false
        questionLabel.text = quizQuestion.question
        choice1Button.setTitle(quizQuestion.choices[0], for: .normal)
        choice2Button.setTitle(quizQuestion.choices[1], for: .normal)
        choice3Button.setTitle(quizQuestion.choices[2], for: .normal)
        // Show option4 button only if 4 options are present
        if (quizQuestion.choices.count == 3) {
            removeChoice4Button()
        } else {
            choice4Button.setTitle(quizQuestion.choices[3], for: .normal)
            accomodateChoice4Button()
        }
        playAgainButton.isHidden = true
        resetTimer()
        timerLabel.isHidden = false
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
            quiz.soundGenerator.playWinnerSound(gotChampion: true)
        } else if quiz.correctQuestions > quiz.questionsPerRound / 2 {
            questionLabel.text = "Awesome! You got \(quiz.correctQuestions) out of \(quiz.questionsPerRound) right!"
            quiz.soundGenerator.playWinnerSound(gotChampion: false)
        } else {
            questionLabel.text = "You got only \(quiz.correctQuestions) out of \(quiz.questionsPerRound) correct! Try Again?"
            quiz.soundGenerator.playLoserSound()
        }
    }
    
    /// Helper method that gives next round of questions
    func loadNextRound() {
            secondsLeft = 15
            activateButtons()
            displayQuestion()
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
        // Set font and title color of buttons to reflect the re-activated state
        choice1Button.setTitleColor(UIColor.white, for: .normal)
        choice2Button.setTitleColor(UIColor.white, for: .normal)
        choice3Button.setTitleColor(UIColor.white, for: .normal)
        choice4Button.setTitleColor(UIColor.white, for: .normal)
        resetButtonColors()
    }
    
    /// Helper method to deactivate buttons
    func deactivateButtons() {
        choice1Button.isUserInteractionEnabled = false
        choice2Button.isUserInteractionEnabled = false
        choice3Button.isUserInteractionEnabled = false
        choice4Button.isUserInteractionEnabled = false
    }
    
    /// Helper method to dim buttons to indicate 'deactivated' status
    func dimButtons() {
        choice1Button.setTitleColor(UIColor.lightGray, for: .normal)
        choice2Button.setTitleColor(UIColor.lightGray, for: .normal)
        choice3Button.setTitleColor(UIColor.lightGray, for: .normal)
        choice4Button.setTitleColor(UIColor.lightGray, for: .normal)
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
        dimButtons()
        resultLabel.isHidden = true
        if quiz.questionsAsked == quiz.questionsPerRound {
            resultLabel.textColor = UIColor.white
            resultLabel.text = "Game Over!"
            displayScore()
            gameTimer.invalidate()
            quiz.askedQuestionsIndices = []
            quiz.questionsAsked = 0
            quiz.correctQuestions = 0
        } else {
            playAgainButton.setTitle("Next Question", for: .normal)
            playAgainButton.isHidden = false
        }
    }
    
    /// Helper method to re-space the position of buttons
    func adjustPositions(ofButtons buttons: Int) {
        for constraint in self.view.constraints {
            if constraint.identifier == "flexiConstraint" {
                if buttons == 3 {
                    constraint.constant = 52
                } else if buttons == 4 {
                    constraint.constant = 18
                }
            }
        }
        view.layoutIfNeeded()
    }
    
    /// Helper method to remove choice4Button and respace remaining choice buttons
    func removeChoice4Button() {
        choice4Button.removeFromSuperview()
        adjustPositions(ofButtons: 3)
    }
    
    /// Helper method to re-space the 3 choice buttons and then add and accomodate a fourth button
    func accomodateChoice4Button() {
        view.addSubview(choice4Button)
        NSLayoutConstraint.activate([
            choice4Button.topAnchor.constraint(equalTo: choice3Button.bottomAnchor, constant: 18),
            choice4Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            choice4Button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            choice4Button.heightAnchor.constraint(equalToConstant: 50)
        ])
        adjustPositions(ofButtons: 4)
    }
}
