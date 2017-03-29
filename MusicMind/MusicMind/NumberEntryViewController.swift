//
//  NumberEntryViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/29/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class NumberEntryViewController: UIViewController {
    
    @IBOutlet weak var numberEntryTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
    @IBAction func attemptValidation(_ sender: Any) {
        
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
