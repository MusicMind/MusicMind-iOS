//
//  ForgotPasswordViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var userForgotEmail: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func emailFieldDidChange(_ sender: UITextField) {
        if let email = sender.text {
            EmailVerifier.isValid(email: email, completion: { valid in
                if valid {
                    resetButton.isEnabled = true
                    resetButton.isHidden = false
                } else {
                    resetButton.isEnabled = false
                    resetButton.isHidden = true
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.isEnabled = false
        resetButton.isHidden = true
    }

    @IBAction func didPressGetResetLink(_ sender: UIButton) {
        if let email = userForgotEmail.text {
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else  {

                // TODO : - Check email message
                
                let alerController = UIAlertController(title: "Email Sent", message: "Please check your inbox 😎", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        self.goToLogin()
                })
                
                alerController.addAction(okAction)
                
                self.present(alerController, animated: true, completion: nil)

                
            }
            
        })
        }
    }
    
    func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    

}
