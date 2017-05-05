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
        
        setupNavigationBar(theme: .light)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordField.text = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
