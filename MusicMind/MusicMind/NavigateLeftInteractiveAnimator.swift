//
//  NavigateLeftInteractiveAnimator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class NavigateLeftInteractiveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var targetEdge: UIRectEdge?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let duration = Double(1.0)
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let toFrame = transitionContext.initialFrame(for: toViewController)
        
        let containerView = transitionContext.containerView
        
        let isPresenting = (toViewController.presentingViewController == fromViewController)
        
        var offset: CGVector!
        if let targetEdge = targetEdge {
            switch targetEdge {
            case UIRectEdge.left:
                offset = CGVector(dx: 1.0, dy: 0.0)
            case UIRectEdge.right:
                offset = CGVector(dx: -1.0, dy: 0.0)
            default:
                offset = CGVector(dx: 0.0, dy: 0.0)
            }
        }
        
        if isPresenting {
            // For a presentation, the toView starts off-screen and slides in.
            fromView.frame = fromFrame
            toView.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1,
                                             dy: toFrame.size.height * offset.dy * -1)
        } else {
            fromView.frame = fromFrame
            toView.frame = toFrame
        }
        
        // We are responsible for adding the incoming view to the containerView for presentation.
        if isPresenting {
            containerView.addSubview(toView)
        } else {
            // addSubview places it's argument at the fron of the subview stack. For dismissal animation we want the fromView to slide away, revealing the toView. Therefor we must place the toView under the fromView.
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 

            if isPresenting {
                toView.frame = fromFrame
            } else {
                // For dismissal the fromView slides off the screen.
                
                fromView.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx,
                                                    dy: fromFrame.size.height * offset.dy)
            }
            
        }) { (finished) in
            let wasCancelled = transitionContext.transitionWasCancelled
            
            if wasCancelled {
                toView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
}
