//
//  EmailPasswordViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/30/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    var newUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newUser = self.newUser,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmedPassword = passwordConfirmationTextField.text,
            password == confirmedPassword else {
                let alertController = UIAlertController(title: "Error", message: "Please make sure all fields are filled and passwords match.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    self.passwordTextField.text = nil
                    self.passwordConfirmationTextField.text = nil
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
        }
        
        newUser.firebaseUserEmail = email
        newUser.firebaseUserPassword = password
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            newUser.firebaseUUID = user?.uid
        })
        
    }

}

