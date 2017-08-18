//
//  optionsViewController.swift
//  AmericanFootball
//
//  Created by Jonathan Gadsden on 11/08/2017.
//  Copyright © 2017 Jonathan Gadsden. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var homeTeamTown: UITextField!
    @IBOutlet weak var homeTeamName: UITextField!
    @IBOutlet weak var awayTeamTown: UITextField!
    @IBOutlet weak var awayTeamName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGame" {
            let gameScreen = segue.destination as! MainViewController
            gameScreen.homeTeamCity = homeTeamTown.text
            gameScreen.homeTeamName = homeTeamName.text
            gameScreen.awayTeamCity = awayTeamTown.text
            gameScreen.awayTeamName = awayTeamName.text
        }
    }

    
    
}
