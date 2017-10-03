//
//  optionsViewController.swift
//  AmericanFootball
//
//  Created by Jonathan Gadsden on 11/08/2017.
//  Copyright © 2017 Jonathan Gadsden. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var homeTeamPicker: UIPickerView!
    @IBOutlet weak var awayTeamPicker: UIPickerView!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!

    let pickerData = [
        ["Arizona","Atlanta","Baltimore","Buffalo","Carolina","Chicago","Cincinnati","Cleveland","Dallas","Denver","Detroit","Green Bay","Houston","Indianapolis","Jacksonville","Kansas City","Los Angeles Chargers","Los Angeles Rams","Miami","Minnesota","New England","New Orleans","New York Giants","New York Jets","Oakland","Philadelphia","Pittsburgh","San Francisco","Seattle","Tampa Bay","Tennessee","Washington"],
        ]
    
    let sizeComponent = 0
    
    //MARK: - Picker View Data Sources and Delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        updateLabel()
    }
    
    //MARK: - Instance Methods
    func updateLabel(){
        let homeTeam = pickerData[sizeComponent][homeTeamPicker.selectedRow(inComponent: sizeComponent)]
        let awayTeam = pickerData[sizeComponent][awayTeamPicker.selectedRow(inComponent: sizeComponent)]
        homeTeamLabel.text = homeTeam
        awayTeamLabel.text = awayTeam
        
        if homeTeam == awayTeam {
            startGameButton.isEnabled = false
        } else {
            startGameButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTeamPicker.delegate = self
        homeTeamPicker.dataSource = self
        homeTeamPicker.selectRow(31, inComponent:sizeComponent, animated: false)
        awayTeamPicker.delegate = self
        awayTeamPicker.dataSource = self
        awayTeamPicker.selectRow(0, inComponent:sizeComponent, animated: false)
        updateLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGame" {
            let (homeTeamCity, homeTeamName, homeTeamDefRating, homeTeamOffRating, homeTeamColour) = obtainOtherTeamInfo(TeamName: homeTeamLabel.text!)
            let (awayTeamCity, awayTeamName, awayTeamDefRating, awayTeamOffRating, awayTeamColour) = obtainOtherTeamInfo(TeamName: awayTeamLabel.text!)
            let gameScreen = segue.destination as! MainViewController
            gameScreen.homeTeamCity = homeTeamCity
            gameScreen.homeTeamName = homeTeamName
            gameScreen.homeTeamDefRating = homeTeamDefRating
            gameScreen.homeTeamOffRating = homeTeamOffRating
            gameScreen.homeTeamColour = homeTeamColour
            gameScreen.awayTeamCity = awayTeamCity
            gameScreen.awayTeamName = awayTeamName
            gameScreen.awayTeamDefRating = awayTeamDefRating
            gameScreen.awayTeamOffRating = awayTeamOffRating
            gameScreen.awayTeamColour = awayTeamColour
        }
    }
    
    func obtainOtherTeamInfo(TeamName: String) -> (String, String, Int, Int, UIColor) {
        var teamCity = TeamName
        var teamName: String!
        var defStrength: Int!
        var offStrength: Int!
        var teamColour: UIColor!
        
        switch TeamName {
        case "Arizona":
            teamName = "Cardinals"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.red
        case "Atlanta":
            teamName = "Falcons"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.red
        case "Baltimore":
            teamName = "Ravens"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.purple
        case "Buffalo":
            teamName = "Bills"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Carolina":
            teamName = "Panthers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Chicago":
            teamName = "Bears"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Cincinnati":
            teamName = "Bengals"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.orange
        case "Cleveland":
            teamName = "Browns"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.orange
        case "Dallas":
            teamName = "Cowboys"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.gray
        case  "Denver":
            teamName = "Broncos"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Detroit":
            teamName = "Lions"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Green Bay":
            teamName = "Packers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.yellow
        case "Houston":
            teamName = "Texans"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Indianapolis":
            teamName = "Colts"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Jacksonville":
            teamName = "Jaguars"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.black
        case "Kansas City":
            teamName = "Chiefs"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.red
        case "Los Angeles Chargers":
            teamCity = "LA"
            teamName = "Chargers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Los Angeles Rams":
            teamCity = "LA"
            teamName = "Rams"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Miami":
            teamName = "Dolphins"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.orange
        case "Minnesota":
            teamName = "Vikings"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.purple
        case "New England":
            teamName = "Patriots"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "New Orleans":
            teamName = "Saints"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.black
        case "New York Giants":
            teamCity = "New York"
            teamName = "Giants"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "New York Jets":
            teamCity = "New York"
            teamName = "Jets"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.white
        case "Oakland":
            teamName = "Raiders"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.black
        case "Philadelphia":
            teamName = "Eagles"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.white
        case "Pittsburgh":
            teamName = "Steelers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.black
        case "San Francisco":
            teamName = "49ers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.red
        case "Seattle":
            teamName = "Seahawks"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Tampa Bay":
            teamName = "Buccaneers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.red
        case "Tennessee":
            teamName = "Titans"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.blue
        case "Washington":
            teamName = "Redskins"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.red
        default:
            teamCity = "Bradford"
            teamName = "Badgers"
            defStrength = 99
            offStrength = 99
            teamColour = UIColor.black
        }
        return (teamCity, teamName, defStrength, offStrength, teamColour)
    }

    
    
}
