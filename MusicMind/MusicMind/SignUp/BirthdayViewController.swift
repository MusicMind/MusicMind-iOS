//
//  BirthdayViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/29/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {

    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var newUser: User?
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }

}
