//
//  ViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // TODO: Disable button if email || password fields are nil. Use textFieldDelegate to check everytime keypress.
    
    @IBAction func attemptSignIn(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                
                print(user?.uid)
                
                self.view.backgroundColor = .green
                
                let cameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController")
                self.present(cameraViewController, animated: true, completion: nil)
            } else {
                
                print(error.debugDescription)
                
                self.view.backgroundColor = .red
            }
        })
    }
    
//    @IBAction func attemptSignUp(_ sender: Any) {
//        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
//            if error == nil {
//                self.view.backgroundColor = .blue
//                
//                print(user?.uid)
//                
//            } else {
//                self.view.backgroundColor = UIColor.brown
//            }
//        })
//    }
    
//    @IBAction func showCameraButtonPressed(_ sender: Any) {
//        // Show the camera view controller
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

