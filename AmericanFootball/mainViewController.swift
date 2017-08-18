//
//  ViewController.swift
//  AmericanFootball
//
//  Created by Jonathan Gadsden on 17/07/2017.
//  Copyright © 2017 Jonathan Gadsden. All rights reserved.
//

import UIKit

var homeScore = 0
var awayScore = 0
var teamInPossession = 1
var currentQuarter = 1
var timeRemaining = "15:00"
var currentDown = 1
var yardsToGo = 10
var ballOn = 25
var playTime = 45
var yardsGained = 0

class MainViewController: UIViewController {

    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var kickButton: UIButton!
    @IBOutlet weak var timeOutButton: UIButton!
    @IBOutlet weak var changeTeamButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var homePossession: UIImageView!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var awayPossession: UIImageView!
    @IBOutlet weak var quarter: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var toGoLabel: UILabel!
    @IBOutlet weak var ballHalfLabel: UILabel!
    @IBOutlet weak var ballOnLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var homeTeamCity: String!
    var homeTeamName: String!
    var awayTeamCity: String!
    var awayTeamName: String!
    var offencePlay: Int!
    var defencePlay: Int!
    
    enum PlayType: Int {
        case pass = 0, run, kick
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable unimplemented buttons
        changeTeamButton.isEnabled = false
        // Initialise variables
        homeScore = 0
        awayScore = 0
        teamInPossession = 1
        homePossession.isHidden = false
        awayPossession.isHidden = true
        currentQuarter = 1
        timeRemaining = "15:00"
        currentDown = 1
        yardsToGo = 10
        ballOn = 25
        playTime = 45
        homeTeamNameLabel.text = homeTeamCity + " " + homeTeamName
        awayTeamNameLabel.text = awayTeamCity + " " + awayTeamName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performPlay(_ sender: UIButton) {
        // set result text to blank
        resultLabel.text = ""
        // Assume that home team is human team for now
        if teamInPossession == 1 {
            // Human is offence
            switch (PlayType(rawValue: sender.tag)!) {
            case .run:
                offencePlay = 1
            case .pass:
                offencePlay = 2
            case .kick:
                offencePlay = 3
            }
        } else {
            // Human is defence
            switch (PlayType(rawValue: sender.tag)!) {
            case .run:
                defencePlay = 1
            case .pass:
                defencePlay = 2
            case .kick:
                defencePlay = 3
            }
        }
        
        // Need to select opposition play
        selectComputerPlay()
        
        // Execute the play based on the offensive selection
        switch offencePlay {
        case 1:
            executeRun()
            playCompletion()
        case 2:
            executePass()
            playCompletion()
        case 3:
            executeKick()
        default:
            executeRun()
        }
        refreshScoreboardAfterPlay()
    }
    
    func refreshScoreboardAfterPlay() {
        homeScoreLabel.text = "\(homeScore)"
        awayScoreLabel.text = "\(awayScore)"
        downLabel.text = "\(currentDown)"
        toGoLabel.text = "\(yardsToGo)"

        //calculate which half the ball is on
        if ballOn > 50 {
            let displayYards = 100 - ballOn
            ballOnLabel.text = "\(displayYards)"
            if teamInPossession == 1 {
                ballHalfLabel.text = awayTeamName
            } else {
                ballHalfLabel.text = homeTeamName
            }
        } else {
            ballOnLabel.text = "\(ballOn)"
            if teamInPossession == 1 {
                ballHalfLabel.text = homeTeamName
            } else {
                ballHalfLabel.text = awayTeamName
            }
        }
        // Reset the play clock
        playTimeLabel.text = "45"
    }
    
    func selectComputerPlay() {
        if teamInPossession == 1 {
        // Computer is defending
            if currentDown == 4 {
                defencePlay = 3
            } else {
                // just randomise defence play
                defencePlay = Int(arc4random_uniform(2)+1)
            }
        } else {
            // Computer is attacking
            if currentDown == 4 {
                offencePlay = 3
            } else {
                // just randomise offence play
                offencePlay = Int(arc4random_uniform(2)+1)
            }
        }
    }
    
    func executeRun() {
        // for now a random gain up to 10 yards
        // defending has no effect
        yardsGained = Int(arc4random_uniform(11))
        resultLabel.text = "\(yardsGained) yards gained"
        resultLabel.textColor = UIColor.black
        // need a fumble here
        // need out of bounds
    }
    
    func executePass() {
        // need interceptions
        // need catch distance then after catch distance
        // out of bounds needed
        // do pass completion first - for now 75% success
        // defending has no effect
        let passCompletion = Int(arc4random_uniform(100))
        if passCompletion > 75 {
            yardsGained = 0
            resultLabel.text = "Pass Incomplete"
            resultLabel.textColor = UIColor.black
        } else {
            // for now a random gain up to 15 yards
            yardsGained = Int(arc4random_uniform(16))
            resultLabel.text = " Pass Complete - \(yardsGained) yards gained"
            resultLabel.textColor = UIColor.black
        }
    }
    
    func executeKick() {
        // Lets see if it is going to be blocked
        let blocked = blockKick()
        // Lets see how long it is going be (up to 45 yards)
        let kickLength = Int(arc4random_uniform(45))
        let distanceToKick = 100 - ballOn
        
        // Need some logic around being wide here

        // Work out if it was good or not
        if blocked == false && kickLength > distanceToKick {
            score(ScoreType: "fieldGoal")
            resultLabel.text = "Field Goal Was Good!!!"
            resultLabel.textColor = UIColor.red
            // this is a fudge - need to sort out later
            ballOn = 75
        } else {
            if blocked == true {
                resultLabel.text = "The kick was blocked!!"
            } else {
                resultLabel.text = "The kick was short"
            }
        }
        // Sort all the impacts of the kick
        yardsGained = 0
        currentDown = 1
        switchPossession()
        yardsToGo = 10
        ballOn = 100 - ballOn
    }
    
    func blockKick() -> Bool {
        if defencePlay != 3 {
            return false
        }
        // Use 2% blocking factor
        if Int(arc4random_uniform(50)) == 0 {
            return true
        }
        return false
     }
    
    func score(ScoreType: String) {
        var score = 0
        
        switch (ScoreType) {
            case "touchdown":
                score = 7
            case "fieldGoal":
                score = 3
            case "safety":
                score = 2
            case "twoPointConversion":
                score = 2
            case "extraPoint":
                score = 1
            default:
                score = 0
        }
        
        if teamInPossession == 1 {
            homeScore += score
        }
        else {
            awayScore += score
        }
    }
    
    func playCompletion() {
        ballOn += yardsGained
        yardsToGo -= yardsGained

        if ballOn > 100 {
            score(ScoreType: "touchdown")
            resultLabel.text = "TOUCHDOWN!!!!"
            resultLabel.textColor = UIColor.blue
            // this is wrong and needs changing
            ballOn = 25
            switchPossession()
        }
        
        if ballOn < 0 {
            score(ScoreType: "safety")
            resultLabel.text = "Tackled in the endzone for a Safety"
            resultLabel.textColor = UIColor.blue
            // this is wrong and needs changing
            ballOn = 25
        }
        
        if yardsToGo < 1 {
            currentDown = 1
            if ballOn > 89 {
                yardsToGo = 100 - ballOn
            }
            else {
                yardsToGo = 10
            }
        }
        else {
            currentDown += 1
        }
        
        if currentDown >= 5 {
            currentDown = 1
            yardsToGo = 10
            yardsToGo = 100 - ballOn
            switchPossession()
        }
    }
    
    func switchPossession() {
        if teamInPossession == 1 {
            homePossession.isHidden = true
            awayPossession.isHidden = false
            teamInPossession = 2
        }
        else {
            homePossession.isHidden = false
            awayPossession.isHidden = true
            teamInPossession = 1
        }
    }
}

