//
//  CameraCapturePushAnimator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

class CameraCapturePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let duration = Double(1.0)
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let isPresenting = toViewController?.presentingViewController == fromViewController
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview((toViewController?.view)!)
        
        transitionContext.completeTransition(true)
        
    }
    
}