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
    
    @IBAction func attemptLogIn(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                self.view.backgroundColor = .green
                
                // Let's update the user info in firebase just in case it's not already in there
                if let authUser = FIRAuth.auth()?.currentUser {
                    let userRef = FIRDatabase.database().reference().child("users/\(authUser.uid)")
                    
                    var user = User()
                    user.id = authUser.uid
                    user.email = authUser.email
                    
                    userRef.updateChildValues(user.asDictionary, withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Updated user id and password")
                        }
                    })
                }
                
                self.goToCameraCapture()
            } else {
                print(error.debugDescription)
                
                self.view.backgroundColor = .red
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(theme: .light)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordField.text = nil
    }
    
    func goToCameraCapture() {
        let storyboard = UIStoryboard.init(name: "CameraCapture", bundle: nil)
        weak var cameraCaptureNavigationController = storyboard.instantiateViewController(withIdentifier: "CameraCaptureNavigationController")
        
        self.present(cameraCaptureNavigationController!, animated: true, completion: nil)
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
