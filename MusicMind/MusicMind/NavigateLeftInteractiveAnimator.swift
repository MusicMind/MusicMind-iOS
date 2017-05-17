//
//  NavigateLeftInteractiveAnimator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class NavigateLeftInteractiveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
//    var targetEdge: UIRectEdge?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let duration = Double(5.0)
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        var goingToMusicSearch = true
        
        if toViewController is MusicSearchViewController {
            goingToMusicSearch = true
        } else if toViewController is CameraCaptureViewController {
            goingToMusicSearch = false
        }

        let offToLeftSideFrame = CGRect(x: -1 * fromFrame.width, y: 0, width: fromFrame.width, height: fromFrame.height)
        let onScreenFrame = CGRect(x: 0, y: 0, width: fromFrame.width, height: fromFrame.height)
        let offToRightSideFrame = CGRect(x: fromFrame.width, y: 0, width: fromFrame.width, height: fromFrame.height)
        
        
        if goingToMusicSearch {
            // For a presentation, the toView starts off-screen and slides in.
            fromView.frame = onScreenFrame // cam
            toView.frame = offToLeftSideFrame // music
            
            containerView.addSubview(toView)
        } else {
            fromView.frame = onScreenFrame // music
            toView.frame = offToRightSideFrame // cam
        }
        
        toView.alpha = 1.0
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 

            if goingToMusicSearch {
                fromView.frame = offToRightSideFrame // cam
                toView.frame = onScreenFrame // music
            } else {
                fromView.frame = offToLeftSideFrame // music
                toView.frame = onScreenFrame // came
                toView.alpha = 1.0
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
