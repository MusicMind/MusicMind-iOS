//
//  ValidationCodeEntryViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/29/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import SinchVerification

class ValidationCodeEntryViewController: UIViewController {

    var verification: Verification!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func attemptToVerify(_ sender: Any) {
        statusLabel.text = "Checking..."
        
        verification.verify(pinTextField.text!) { (success, error) in
            if success {
                self.statusLabel.text = "Verified!"
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = nil
    }

}
