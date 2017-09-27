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
var timeRemaining = 900
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
    @IBOutlet weak var eventLabel: UILabel!

    var homeTeamCity: String!
    var homeTeamName: String!
    var awayTeamCity: String!
    var awayTeamName: String!
    var offencePlay: Int!
    var offenceSubPlay: String!
    var defencePlay: Int!
    var timeUsed = 0
    var turnover = false
    var resultText = ""
    var passType = ""
    var runType = ""
    
    // constants for play types
    let runPlay = 1
    let passPlay = 2
    let kickPlay = 3

    // Big bug in here around 4th down plays that are not kicks
    // Both are going to be best fixed by a code reorganisation
    // Not outputting final result either
    
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
        timeRemaining = 900

        currentDown = 1
        yardsToGo = 10
        ballOn = 20
        playTime = 45
        homeTeamNameLabel.text = homeTeamCity + " " + homeTeamName
        awayTeamNameLabel.text = awayTeamCity + " " + awayTeamName
        eventLabel.text = " "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performPlay(_ sender: UIButton) {
        // set result text to blank
        resultLabel.text = ""
        resultText = ""
        eventLabel.text = ""
        turnover = false
        // Assume that home team is human team for now
        if teamInPossession == 1 {
            // Human is offence
            switch (PlayType(rawValue: sender.tag)!) {
            case .run:
                let runController = UIAlertController()
                runController.title = "Run Selection"
                runController.message = "Select the type of run:"
                
                let insideAction = UIAlertAction(title: "Inside", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.runPlay, subPlayType: "inside") }
                let outsideAction = UIAlertAction(title: "Outside", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.passPlay, subPlayType: "outside") }
                
                runController.addAction(insideAction)
                runController.addAction(outsideAction)
                self.present(runController, animated: true, completion: nil)
            case .pass:
                let passController = UIAlertController()
                passController.title = "Pass Selection"
                passController.message = "Select the type of pass:"
                
                let shortAction = UIAlertAction(title: "Short", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.passPlay, subPlayType: "short")
                }
                let mediumAction = UIAlertAction(title: "Medium", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.passPlay, subPlayType: "medium") }
                let longAction = UIAlertAction(title: "Long", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.passPlay, subPlayType: "long") }
                
                passController.addAction(shortAction)
                passController.addAction(mediumAction)
                passController.addAction(longAction)
                self.present(passController, animated: true, completion: nil)
            case .kick:
                let kickController = UIAlertController()
                kickController.title = "Kick Selection"
                kickController.message = "Select the type of kick:"
                
                let fieldGoalAction = UIAlertAction(title: "Field Goal", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.kickPlay, subPlayType: "fieldGoal") }
                let puntAction = UIAlertAction(title: "Punt", style: UIAlertActionStyle.default) { action in self.executePlay(playType: self.kickPlay, subPlayType: "punt") }
                
                kickController.addAction(fieldGoalAction)
                kickController.addAction(puntAction)
                self.present(kickController, animated: true, completion: nil)
            }
        } else {
            // Human is defence
            switch (PlayType(rawValue: sender.tag)!) {
            case .run:
                defencePlay = runPlay
            case .pass:
                defencePlay = passPlay
            case .kick:
                defencePlay = kickPlay
            }
            executePlay(playType: defencePlay, subPlayType: "")
        }
    }
    
    // this is looking to replace nearly everything in PerformPlay
    func executePlay(playType: Int, subPlayType: String) {
        // Assume that home team is human team for now
        if teamInPossession == 1 {
            // Human is offence
            offencePlay = playType
            offenceSubPlay = subPlayType
        } else {
            // Human is defence
            defencePlay = playType
        }
        
        selectComputerPlay()
        
        switch offencePlay {
        case runPlay:
            executeRun(runType: offenceSubPlay)
            playCompletion()
        case passPlay:
            executePass(passType: offenceSubPlay)
            playCompletion()
        case kickPlay:
            if offenceSubPlay == "fieldGoal" {
                executeKick()
            } else {
                executePunt()
            }
        default:
            executeRun(runType: "")
            playCompletion()
            print("something went wrong and fell to default statement")
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
                defencePlay = kickPlay
            } else {
                // just randomise defence play
                defencePlay = Int(arc4random_uniform(2)+1)
            }
        } else {
            // Computer is attacking
            if currentDown == 4 {
                offencePlay = kickPlay
                if ballOn < 60 {
                    offenceSubPlay = "punt"
                } else {
                    offenceSubPlay = "fieldGoal"
                }
            } else {
                // just randomise offence play
                offencePlay = Int(arc4random_uniform(2)+1)
                // need to select a sub play
                if offencePlay == 2 {
                    // always go short for now
                    offenceSubPlay = "short"
                } else {
                    // always go inside for now
                    offenceSubPlay = "inside"
                }
            }
        }
    }
    
    func executeRun(runType: String) {
        // for now a random gain up to 11 yards - weighted to centre by using 3 variables
        // first decide whether this is a big play - more than 10 yards (11% are)
        let randomOne = Int(arc4random_uniform(100))
        var bigPlayChance = 11
        var reduceGain = 3
        
        // if defence has gone run (1) then reduce chance of big play by half
        // also reduce yards gained by more yards
        if defencePlay == runPlay {
            bigPlayChance = 6
            reduceGain = 5
        }
        
        if randomOne > bigPlayChance {
            let randomOne = Int(arc4random_uniform(5))
            let randomTwo = Int(arc4random_uniform(5))
            let randomThree = Int(arc4random_uniform(6))
            yardsGained = randomOne + randomTwo + randomThree - reduceGain
        } else {
            let randomOne = Int(arc4random_uniform(15))
            let randomTwo = Int(arc4random_uniform(15))
            let randomThree = Int(arc4random_uniform(15))
            yardsGained = randomOne + randomTwo + randomThree
        }

        if yardsGained < 0 {
            resultLabel.text = "\(yardsGained) yards lost"
            resultText = "\(yardsGained) yards lost"

        } else {
            resultLabel.text = "\(yardsGained) yards gained"
            resultText = "\(yardsGained) yards gained"
        }

        resultLabel.textColor = UIColor.black
        timeUsed = 40
        // need a fumble here - use a 1.5% chance
        let fumbled = Int(arc4random_uniform(200))
        if fumbled < 3 {
            let recovered = Int(arc4random_uniform(100))
            if recovered < 44 {
                turnover = true
                resultLabel.text = "Fumble lost - \(yardsGained) downfield"
                ballOn += yardsGained
                timeUsed = 20
                switchPossession()
                return
            } else {
                resultLabel.text = "Fumble regained - \(yardsGained) downfield"
                return
            }
        }
        // need out of bounds
    }
    
    func executePass(passType: String) {
        print("pass type= \(passType)")
        // see if there is a sack first - go for 4.5% for run or 8.5% for pass defence
        let sacked = Int(arc4random_uniform(200))
        // need interceptions - go for 2.5% chance overall
        let intercepted = Int(arc4random_uniform(200))
        // 11% chance of a big play (>25 yards)
        let bigPlay = Int(arc4random_uniform(100))
        
        // default chances of events
        var sackChance = 9
        var interceptChance = 3
        var bigChance = 5
        var reduceGain = 1
        var increaseGain = 10
        
        // set up defence effects if defence is a pass
        if defencePlay == passPlay {
            sackChance = 17
            interceptChance = 7
            bigChance = 17
            reduceGain = 4
            increaseGain = 2
        }

        if sacked < sackChance {
            let randomOne = Int(arc4random_uniform(7))
            let randomTwo = Int(arc4random_uniform(6))
            let randomThree = Int(arc4random_uniform(6))
            let yardsLost = randomOne + randomTwo + randomThree
            resultLabel.text = "QB sacked - \(yardsLost) yards lost"
            yardsGained = 0 - yardsLost
            if ballOn < 1 {
                currentDown = 1
                yardsToGo = 10
                switchPossession()
                score(ScoreType: "safety")
                switchPossession()
                ballOn = 25
                resultLabel.text = resultLabel.text! + " - SAFETY!"
            }
            timeUsed = 20
            return
        }
        
        if intercepted < interceptChance {
            turnover = true
            let randomOne = Int(arc4random_uniform(7))
            let randomTwo = Int(arc4random_uniform(6))
            let randomThree = Int(arc4random_uniform(6))
            yardsGained = randomOne + randomTwo + randomThree - 1
            resultLabel.text = "Pass intercepted - \(yardsGained) downfield"
            ballOn += yardsGained
            if ballOn > 99 {
                ballOn = 80
                resultLabel.text = resultLabel.text! + " - touchback"
            }
            timeUsed = 20
            switchPossession()
            return
        }
        
        // need catch distance then after catch distance
        // out of bounds needed
        // do pass completion first - for now 63% success
        let passCompletion = Int(arc4random_uniform(100))
        if passCompletion > 63 {
            yardsGained = 0
            resultLabel.text = "Pass - Incomplete"
            resultText = "Pass - Incomplete"
            resultLabel.textColor = UIColor.black
            timeUsed = 10
        } else {
            if bigPlay > bigChance {
                let randomOne = Int(arc4random_uniform(6))
                let randomTwo = Int(arc4random_uniform(6))
                let randomThree = Int(arc4random_uniform(6))
                let randomFour = Int(arc4random_uniform(6))
                yardsGained = randomOne + randomTwo + randomThree + randomFour - reduceGain
            } else {
                let randomOne = Int(arc4random_uniform(11))
                let randomTwo = Int(arc4random_uniform(11))
                let randomThree = Int(arc4random_uniform(11))
                let randomFour = Int(arc4random_uniform(11))
                yardsGained = randomOne + randomTwo + randomThree + randomFour + increaseGain
            }

            // do impact of result
            switch yardsGained {
            case 0:
                resultLabel.text = " Pass Complete - no gain"
                resultText = " Pass Complete - no gain"
                resultLabel.textColor = UIColor.black
            case -1:  // can get away with this as only negative can be -1, not very elegant
                resultLabel.text = " Pass Complete - \(yardsGained) yards lost"
                resultText = " Pass Complete - \(yardsGained) yards lost"
                resultLabel.textColor = UIColor.black
            default:
                resultLabel.text = " Pass Complete - \(yardsGained) yards gained"
                resultText = " Pass Complete - \(yardsGained) yards gained"
                resultLabel.textColor = UIColor.black
            }
            timeUsed = 40
        }
    }
    
    func executeKick() {
        // Lets see if it is going to be blocked - send a 2% chance
        let blocked = blockKick(blockChance: 50)
        // Lets see how long it is going be (up to 55 yards)
        let kickLength = Int(arc4random_uniform(55))
        let distanceToKick = 100 - ballOn
        
        // Need some logic around being wide here

        // Work out if it was good or not
        if blocked == false && kickLength > distanceToKick {
            score(ScoreType: "fieldGoal")
            resultLabel.text = "Field Goal Was Good!!!"
            resultLabel.textColor = UIColor.red
            // this is a fudge - need to sort out later
            executeKickOff()
        } else {
            if blocked == true {
                resultLabel.text = "The kick was blocked!!"
            } else {
                resultLabel.text = "The kick was short"
            }
            switchPossession()
        }
        // Sort all the impacts of the kick
        yardsGained = 0
        currentDown = 1
        yardsToGo = 10
        timeUsed = 10
    }
    
    func executePunt() {
        // Lets see if it is going to be blocked - send a 2% chance
        let blocked = blockKick(blockChance: 200)
        // if its blocked we've got to work some stuff out
        if blocked == true {
            resultLabel.text = "The punt was blocked"
            currentDown = 1
            yardsToGo = 10
            switchPossession()
            updateClock(secondsUsed: 20)
            return
        }
        
        // Lets see how long it is going be (minimum of 35 maximum 65)
        // for now a random gain up to 30 yards - weighted to centre by using 3 variables
        let randomOne = Int(arc4random_uniform(11))
        let randomTwo = Int(arc4random_uniform(11))
        let randomThree = Int(arc4random_uniform(11))
        
        let kickLength = 35 + randomOne + randomTwo + randomThree
        ballOn += kickLength
        
        // See whether it is a touchback
        if ballOn > 99 {
            currentDown = 1
            yardsToGo = 10
            switchPossession()
            ballOn = 20
            resultLabel.text = "The punt went through the endzone - touchback"
            updateClock(secondsUsed: 20)
            return
        }
        
        // Now we need a return - only return 50% for now - need better logic
        if Int(arc4random_uniform(3)) < 2 {
            resultLabel.text = "The punt was \(kickLength) and it was a fair catch"
            currentDown = 1
            yardsToGo = 10
            switchPossession()
            updateClock(secondsUsed: 20)
            return
        }
        
        let returnLength = Int(arc4random_uniform(20))
        
        resultLabel.text = "The punt was \(kickLength) and it was returned \(returnLength)"
        yardsGained = 0
        currentDown = 1
        switchPossession()
        ballOn += returnLength // this must go after switchPossession
        yardsToGo = 10
        updateClock(secondsUsed: 30)
    }
    
    func blockKick(blockChance: UInt32) -> Bool {
        if defencePlay != 3 {
            return false
        }
        // Use blocking chance passed in - 1 in blockChance of being blocked
        if Int(arc4random_uniform(blockChance)) == 0 {
            return true
        }
        return false
     }
    
    func executeKickOff() {
        // Lets see how long it is going be (minimum of 35 maximum 65)
        // for now a random gain up to 30 yards - weighted to centre by using 3 variables
        let randomOne = Int(arc4random_uniform(17))
        let randomTwo = Int(arc4random_uniform(17))
        let randomThree = Int(arc4random_uniform(17))
        
        let kickLength = 35 + randomOne + randomTwo + randomThree
        ballOn = 35 + kickLength
        
        // See whether it is a touchback
        if ballOn > 99 {
            currentDown = 0
            yardsToGo = 10
            switchPossession()
            ballOn = 20
            eventLabel.text = "The kick off went through the endzone - touchback"
            updateClock(secondsUsed: 10)
            return
        }
        
        let randomFour = Int(arc4random_uniform(200))
        var returnLength = 0
        if randomFour > 0 {
            returnLength = Int(arc4random_uniform(25)) + 10
        } else {
            eventLabel.text = "The kick off was returned for a TOUCHDOWN!"
            switchPossession()
            score(ScoreType: "touchdown")
            return
        }
        
        eventLabel.text = "The kick off was \(kickLength) and it was returned \(returnLength)"
        yardsGained = 0
        currentDown = 0
        switchPossession()
        ballOn += returnLength // this must go after switchPossession
        yardsToGo = 10
        updateClock(secondsUsed: 20)
    }

    func score(ScoreType: String) {
        var score = 0
        
        switch (ScoreType) {
            case "touchdown":
                score = 6
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

        if ballOn > 99 {
            score(ScoreType: "touchdown")
            resultLabel.text = "TOUCHDOWN!!!!"
            resultLabel.textColor = UIColor.blue
            executeExtraPoint()
            executeKickOff()
        }
        
        if ballOn < 0 {
            switchPossession()
            score(ScoreType: "safety")
            resultLabel.text = "Tackled in the endzone for a Safety"
            resultLabel.textColor = UIColor.blue
            executeKickOff()
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
        
        if turnover == true {
            currentDown = 1
            if ballOn > 89 {
                yardsToGo = 100 - ballOn
            } else {
                yardsToGo = 10
            }
        }
        
        if currentDown >= 5 {
            currentDown = 1
            switchPossession()
            if ballOn > 89 {
                yardsToGo = 100 - ballOn
            } else {
                yardsToGo = 10
            }
        }
        /* BLOCK OUT FOR NOW
        let resultController = UIAlertController()
        resultController.title = "Play Result"
        resultController.message = resultText
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default)
        
        resultController.addAction(okAction)
        self.present(resultController, animated: true, completion: nil)
        */
        updateClock(secondsUsed: timeUsed)
    }
    
    func switchPossession() {
        ballOn = 100 - ballOn
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
    
    func executeExtraPoint() {
        let randomOne = Int(arc4random_uniform(200))
        // 6.5% chance of an extra point miss
        if randomOne > 12 {
            score(ScoreType: "extraPoint")
            resultLabel.text = resultLabel.text! + " - Extra point is good!"
        } else {
            resultLabel.text = resultLabel.text! + " - Extra point is missed!"
        }
    }
    
    func updateClock(secondsUsed: Int) {
        timeRemaining -= secondsUsed
        if timeRemaining < 0 {
            timeRemaining = 900
            timeRemainingLabel.text = "15:00"
            currentQuarter += 1
            quarter.text = "\(currentQuarter)"
            if currentQuarter == 3 {
                teamInPossession = 2
                homePossession.isHidden = true
                awayPossession.isHidden = false
                ballOn = 25
                currentDown = 1
                yardsToGo = 10
                eventLabel.text = "HALF TIME"
            }
            if currentQuarter == 5 {
                if homeScore > awayScore {
                    eventLabel.text = homeTeamCity + " " + homeTeamName + " wins " + "\(homeScore)-\(awayScore)"
                } else if awayScore > homeScore {
                    eventLabel.text = awayTeamCity + " " + awayTeamName + " wins " + "\(awayScore)-\(homeScore)"
                } else {
                    eventLabel.text = "It's a tie \(homeScore)-\(awayScore)"
                }
                passButton.isEnabled = false
                runButton.isEnabled = false
                kickButton.isEnabled = false
                timeOutButton.isEnabled = false
                changeTeamButton.isEnabled = false
            }
        }
        // this doesn't look like the best way of doing this!
        let minutesLeft = timeRemaining/60
        let secondsLeft = timeRemaining%60
        
        if secondsLeft == 0 {
            timeRemainingLabel.text = "\(minutesLeft):00"
        } else {
            timeRemainingLabel.text = "\(minutesLeft):\(secondsLeft)"
        }

    }
}

