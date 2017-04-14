//
//  CameraCaptureViewControllerTransitionAnimator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

class CameraCaptureViewControllerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let duration = Double(1.0)
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview((toViewController?.view)!)
        
        transitionContext.completeTransition(true)
        
    }
    
}
