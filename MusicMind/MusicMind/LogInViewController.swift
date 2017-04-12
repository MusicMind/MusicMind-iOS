//
//  LogInViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    // TODO: Disable button if email || password fields are nil. Use textFieldDelegate to check everytime keypress.
    
    @IBAction func attemptLogIn(_ sender: Any) {
        
        userLoginCredentials.firebaseUserEmail = emailField.text!
        userLoginCredentials.firebaseUserPassword = passwordField.text!

        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                self.view.backgroundColor = .green
                
                self.goToCameraCapture()
            } else {
                
                print(error.debugDescription)
                
                self.view.backgroundColor = .red
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.emailField.layer.borderWidth = 1
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.cornerRadius = self.emailField.frame.height/2
        
        self.passwordField.layer.borderWidth = 1
        self.passwordField.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordField.layer.cornerRadius = self.emailField.frame.height/2
        
        self.logInButton.layer.cornerRadius = self.logInButton.frame.height/2
        
        self.forgotPasswordButton.layer.cornerRadius = self.forgotPasswordButton.frame.height/2
        self.forgotPasswordButton.layer.borderWidth = 1
        self.forgotPasswordButton.layer.borderColor = UIColor.init(colorLiteralRed: 240/255.0, green: 10/255.0, blue: 136/255.0, alpha: 1).cgColor
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let email = userLoginCredentials.firebaseUserEmail {
            emailField.text = email
        }
        
        if let password = userLoginCredentials.firebaseUserPassword {
            passwordField.text = password
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if isMovingFromParentViewController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func goToCameraCapture() {
        let storyboard = UIStoryboard.init(name: "CameraCapture", bundle: nil)
        weak var vc = storyboard.instantiateViewController(withIdentifier: "CameraCaptureViewController")
        self.present(vc!, animated: true, completion: nil)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            attemptLogIn(self)
        }
        
        return true
    }
}
