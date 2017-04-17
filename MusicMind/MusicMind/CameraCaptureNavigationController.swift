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
    
//    var edgeGesture: UIScreenEdgePanGestureRecognizer?
    
    var interactionController = NavigateLeftTransitionInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Setup gesture recognizer
//        edgeGesture = UIScreenEdgePanGestureRecognizer(target: interactionController, action: #selector(NavigateLeftTransitionInteractionController.edgeGestureAction(sender:)))
//        
//        if let edgeGesture = edgeGesture {
//            edgeGesture.edges = UIRectEdge.left
//            
//            view.addGestureRecognizer(edgeGesture)
//        }
        
        delegate = self
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
