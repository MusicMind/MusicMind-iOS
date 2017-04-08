//
//  EmailPasswordViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/30/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EmailPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    var newUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        print(newUser.dictionaryRepresentation)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
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
        
        // Save log in info to keychain
        userLoginCredentials.firebaseUserEmail = email
        userLoginCredentials.firebaseUserPassword = password
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            //TODO: handle error 17001 when the user exists in fire base
            
            self.goToCameraCapture()
            
            // Post new user to firebase
            self.newUser.firebaseUUID = user?.uid
            FirebaseDataService.shared.addUserToUserList(self.newUser)
        })
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func goToCameraCapture() {
        let storyboard = UIStoryboard.init(name: "CameraCapture", bundle: nil)
        weak var vc = storyboard.instantiateViewController(withIdentifier: "CameraCaptureViewController")
        self.present(vc!, animated: true, completion: nil)
    }
}

extension EmailPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else {
            goToCameraCapture()
        }
        
        return true
    }
}
