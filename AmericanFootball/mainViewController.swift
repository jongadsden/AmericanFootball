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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performPlay(_ sender: UIButton) {
       print("before score \(teamInPossession)")
        switch (PlayType(rawValue: sender.tag)!) {
        case .run:
            score(ScoreType: "touchdown")
        case .pass:
            score(ScoreType: "touchdown")
        case .kick:
            score(ScoreType: "fieldGoal")
        }
        print ("after score \(teamInPossession)")
        switchPossession()
        print ("after switching \(teamInPossession)")
        refreshScoreboardAfterPlay()
    }
    
    func refreshScoreboardAfterPlay() {
        homeScoreLabel.text = "\(homeScore)"
        awayScoreLabel.text = "\(awayScore)"
    }
    
    func score(ScoreType: String) {
        var score = 0
        
        switch (ScoreType) {
            case "touchdown":
                score = 7
            case "fieldGoal":
                score = 3
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

