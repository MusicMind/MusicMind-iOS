//
//  NavigateLeftInteractiveAnimator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

class NavigateLeftInteractiveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        if let toView = toView {
            containerView.addSubview(toView)
        }
        
        toView?.alpha = 0
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
            toView?.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
        
    }
    
}
extension NavigateLeftInteractiveAnimator: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // code
    }
    
}
