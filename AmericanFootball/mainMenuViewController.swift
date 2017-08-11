//
//  mainMenuViewController.swift
//  AmericanFootball
//
//  Created by Jonathan Gadsden on 11/08/2017.
//  Copyright © 2017 Jonathan Gadsden. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewController {
    

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var loadGameButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable unused buttons until they are implemented
        loadGameButton.isEnabled = false
        settingsButton.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

