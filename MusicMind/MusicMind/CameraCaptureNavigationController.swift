//
//  CameraCaptureNavigationController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class CameraCaptureNavigationController: UINavigationController {
    
    let pushAnimator = CameraCapturePushAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
}

extension CameraCaptureNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                    animationControllerFor operation: UINavigationControllerOperation,
                                         from fromVC: UIViewController,
                                             to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            return pushAnimator
        } else {
            return pushAnimator // obviously will change when I get around to making a pop animator
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return pushAnimator
    }
    
}
