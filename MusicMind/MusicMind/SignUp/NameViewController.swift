//
//  NameViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var newUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        self.firstNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.firstNameTextField.layer.borderWidth = 1
        self.firstNameTextField.layer.cornerRadius = self.firstNameTextField.frame.size.height/2
    
        self.lastNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.lastNameTextField.layer.borderWidth = 1
        self.lastNameTextField.layer.cornerRadius = self.firstNameTextField.frame.size.height/2
        
        self.signUpButton.backgroundColor = UIColor.init(colorLiteralRed: 255/255.0, green: 0/255.0, blue: 138/255.0, alpha:1)
        self.signUpButton.titleLabel?.textColor = UIColor.white
        self.signUpButton.layer.cornerRadius = self.firstNameTextField.frame.size.height/2
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty else {
                let alertController = UIAlertController(title: "Invalid", message: "Empty first or last name detected. Please make sure both fields are filled.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
        }
        
        newUser.firstName = firstName
        newUser.lastName = lastName
    }
    
}

extension NameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //TODO: disable the signUpButton until there is text in the both first name and last name textfield.
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else {
            performSegue(withIdentifier: "goToBirthdayVC", sender: self)
        }
        
        return true
    }
}
