//
//  ForgotPasswordViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var userForgotEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func didPressGetResetLink(_ sender: UIButton) {
        if let email = userForgotEmail.text {
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {

                // TODO : - Check email message
                
                let alerController = UIAlertController(title: "Email Sent", message: "Please check your inbox 😎", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        self.goToLogin()
                })
                
                alerController.addAction(okAction)
                
                self.present(alerController, animated: true, completion: nil)

                
            }
            
        })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    
    func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    

}
