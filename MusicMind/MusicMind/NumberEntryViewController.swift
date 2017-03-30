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
                            phoneNumber: numberEntryTextField.text!)
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
            
            self.getCodeButton.isEnabled = false
            
/* Example:
            - (void)onTextFieldTextDidChange:(UITextField *)textField {
                void (^update)(BOOL, UIColor *) = ^(BOOL enabled, UIColor *color) {
                    self.verifyButton.enabled = enabled;
                    textField.backgroundColor = color;
                };
                
                if (textField.text.length == 0) {
                    update(NO, [UIColor clearColor]);
                } else if ([SINPhoneNumberUtil() isPossibleNumber:textField.text fromRegion:self.isoCountryCode error:nil]) {
                    update(YES, colorForPossiblePhoneNumber());
                } else {
                    update(NO, colorForNotPossiblePhoneNumber());
                }
            }
*/
            
            
            
            
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
