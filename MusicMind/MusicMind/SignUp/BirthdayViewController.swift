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
    }

    var newUser: User?
    
    
    @IBAction func datePickerValueChange(_ sender: Any) {
        
        continueButton.isEnabled = true
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            return dateFormatter
        }()
        birthdayLabel.text = dateFormatter.string(from: datePicker.date)
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let birthDate = datePicker.date
        let calendar = Calendar.current
        let unitFlags = 
        let dateComponents = Calendar().dateComponents(u, from: <#T##Date#>, to: <#T##Date#>
    }

}
