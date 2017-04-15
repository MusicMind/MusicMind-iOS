//
//  CameraCaptureNavigationController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class CameraCaptureNavigationController: UINavigationController {
    
    let animator = NavigateLeftInteractiveAnimator()
    
    let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction(sender:)))
    
    var interactionController: NavigateLeftTransitionInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactionController = NavigateLeftTransitionInteractionController(gestureRecognizer: edgeGesture, edgeForDragging: UIRectEdge.left)
        
        delegate = self
    }
    
    func interactiveTransitionRecognizerAction(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            if location.x >  CGRectGetMidX(view.bounds) {
                navigationControllerDelegate.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
                [self performSegueWithIdentifier:PushSegueIdentifier sender:self];
            }
        }
    }
    
}

extension CameraCaptureNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                    animationControllerFor operation: UINavigationControllerOperation,
                                         from fromVC: UIViewController,
                                             to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}
