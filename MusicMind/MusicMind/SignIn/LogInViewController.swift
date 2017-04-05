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
    
    // TODO: Disable button if email || password fields are nil. Use textFieldDelegate to check everytime keypress.
    
    @IBAction func attemptLogIn(_ sender: Any) {
        
        userLoginCredentials.firebaseUserEmail = emailField.text!
        userLoginCredentials.firebaseUserPassword = passwordField.text!

        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                self.view.backgroundColor = .green
                
                let spotifyAuthViewController = UIStoryboard(name: "CameraCapture", bundle: nil).instantiateViewController(withIdentifier: "CameraCaptureViewController")
                self.present(spotifyAuthViewController, animated: true, completion: nil)
            } else {
                print(error.debugDescription)
                
                self.view.backgroundColor = .red
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let email = userLoginCredentials.firebaseUserEmail {
            emailField.text = email
        }
        
        if let password = userLoginCredentials.firebaseUserPassword {
            passwordField.text = password
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if isMovingFromParentViewController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    
}

