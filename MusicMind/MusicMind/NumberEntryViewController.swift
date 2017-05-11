//
//  NumberEntryViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/29/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import SinchVerification

class NumberEntryViewController: UIViewController {
    
    var verification: Verification!
    var sinchApplicationKey = "a7047f26-664e-47e5-abf8-02013452c9d4"
    private var formatter: TextFieldPhoneNumberFormatter!
    @IBOutlet weak var numberEntryTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func attemptValidation(_ sender: Any) {
        verification =
            SMSVerification(sinchApplicationKey,
                            phoneNumber: "+1\(numberEntryTextField.text!)")
        verification.initiate { (result, error) in
            if result.success {
                print("success")
                self.performSegue(withIdentifier: "enterPin", sender: sender)
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter = TextFieldPhoneNumberFormatter()
        formatter.textField = numberEntryTextField
        formatter.onTextFieldTextDidChange = { (textField: UITextField) -> () in
            let blankColor = UIColor.clear
            let looksGoodColor = UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
            let looksBadColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
            
            func update(buttonEnabled: Bool, textFieldColor: UIColor) {
                self.getCodeButton.isEnabled = buttonEnabled
                textField.backgroundColor = textFieldColor
            }
            
            if let phoneNumberText = textField.text {
                if SharedPhoneNumberUtil().isPossibleNumber(phoneNumberText, fromRegion: "US").possible {
                    update(buttonEnabled: true, textFieldColor: looksGoodColor)
                } else {
                    update(buttonEnabled: false, textFieldColor: looksBadColor)
                }
            } else {
                update(buttonEnabled: false, textFieldColor: blankColor)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        numberEntryTextField.becomeFirstResponder()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterPin" {
            let vc = segue.destination as! ValidationCodeEntryViewController
            
            vc.verification = self.verification
        }
    }
    
}
