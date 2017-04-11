//
//  WelcomeViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(theme: .light)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
