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
var ballHalf = 1
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
        ballHalf = 1
        ballOn = 25
        playTime = 45
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performPlay(_ sender: UIButton) {
       print("before score \(teamInPossession)")
        switch (PlayType(rawValue: sender.tag)!) {
        case .run:
            yardsGained = 2
        case .pass:
            yardsGained = 6
        case .kick:
            score(ScoreType: "fieldGoal")
        }
        playCompletion()
        refreshScoreboardAfterPlay()
    }
    
    func refreshScoreboardAfterPlay() {
        homeScoreLabel.text = "\(homeScore)"
        awayScoreLabel.text = "\(awayScore)"
        downLabel.text = "\(currentDown)"
        toGoLabel.text = "\(yardsToGo)"
        if ballHalf == 1 {
            ballHalfLabel.text = "Home Team's"
        } else {
            ballHalfLabel.text = "Away Team's"
        }
        ballOnLabel.text = "\(ballOn)"
        playTimeLabel.text = "45"
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
            // this is wrong and needs changing
            switchPossession()
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

