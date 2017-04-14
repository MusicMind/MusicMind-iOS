//
//  CameraCaptureNavigationController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class CameraCaptureNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

extension CameraCaptureNavigationController: UINavigationControllerDelegate {
    
}
