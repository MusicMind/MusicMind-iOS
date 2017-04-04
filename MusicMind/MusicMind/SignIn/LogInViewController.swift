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
        
        user.firebaseUserEmail = emailField.text!
        user.firebaseUserPassword = passwordField.text!

        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                
//                print(user?.uid)
                
                self.view.backgroundColor = .green
                
                let spotifyAuthViewController = UIStoryboard(name: "SpotifyAuth", bundle: nil).instantiateViewController(withIdentifier: "SpotifyAuth")
                self.present(spotifyAuthViewController, animated: true, completion: nil)
            } else {
                
                print(error.debugDescription)
                
                self.view.backgroundColor = .red
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = user.firebaseUserEmail {
            emailField.text = email
        }
        
        if let password = user.firebaseUserPassword {
            passwordField.text = password
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

