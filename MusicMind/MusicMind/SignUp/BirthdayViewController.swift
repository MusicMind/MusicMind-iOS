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
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year!
        
        // MARK: - Age Restriction
        if age < 18 {
            let alerController = UIAlertController(title: "Age Restriction", message: "Must be 18 years or older.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerController.addAction(okAction)
            self.present(alerController, animated: true, completion: { 
                return
            })
        }
        
        if segue.identifier == "toEmailPassword",
            let emailPasswordViewController = segue.destination as? EmailPasswordViewController {
            
            newUser?.birthday = birthDate
            emailPasswordViewController.newUser = newUser
        }
        
    }

}
