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
    @IBOutlet weak var continueButton: UIButton!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        continueButton.isHidden = true;
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        createNewUser()
    }
    
    @IBAction func textChanged(_ sender: Any) {
        if emailTextField.text == nil || passwordTextField.text == nil || passwordConfirmationTextField.text == nil {
            continueButton.isHidden = true
            continueButton.isEnabled = false
            return
        }
        if passwordTextField.text != passwordConfirmationTextField.text || passwordTextField.text == "" || passwordConfirmationTextField.text == "" {
            continueButton.isHidden = true
            continueButton.isEnabled = false
            return
        }
        EmailVerifier.isValid(email: emailTextField.text!, completion: { valid in
            if valid {
                continueButton.isEnabled = true
                continueButton.isHidden = false
            } else {
                continueButton.isEnabled = false
                continueButton.isHidden = true
            }
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
    
    func createNewUser(){
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
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (fbAuthUser, error) in
            //TODO: handle error 17001 when the user exists in fire base
            
            func presentErrorWith(string: String){
                let alertController = UIAlertController(title: "Firebase Error", message: "Error Code: \(string)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    return
                })
            }
            
            if let error = error {
                if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
                    switch errorCode{
                    case .errorCodeInvalidEmail:
                        presentErrorWith(string: "Invalid Email")
                        return
                    case .errorCodeWeakPassword:
                        presentErrorWith(string: "Password too weak")
                        return
                    case .errorCodeEmailAlreadyInUse:
                        presentErrorWith(string: "Email already in use")
                        return
                    default:
                        print(errorCode.rawValue)
                    }
                }
            }
            
            self.goToCameraCapture()
            
            if var user = self.user {
                user.email = fbAuthUser?.email
                user.dateCreated = Date()
                user.id = fbAuthUser?.uid
        
                let newUserRef = FIRDatabase.database().reference().child("users/\(user.id!)")
                
                newUserRef.setValue(user.asDictionary, withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Successfully pushed new user to Firebase")
                    }
                })
            }
        })
        
    }
}

extension EmailPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else {
            createNewUser()
        }
        
        return true
    }
}
