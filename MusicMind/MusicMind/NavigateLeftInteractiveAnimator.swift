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
        let toFrame = transitionContext.initialFrame(for: toViewController)
        
        let containerView = transitionContext.containerView
        
        var goingToMusicSearch = true
        
        if toViewController is MusicSearchViewController {
            goingToMusicSearch = true
        } else if toViewController is CameraCaptureViewController {
            goingToMusicSearch = false
        }
        
//        var offset: CGVector!
//        if let targetEdge = targetEdge {
//            switch targetEdge {
//            case UIRectEdge.left:
//                offset = CGVector(dx: 1.0, dy: 0.0)
//            case UIRectEdge.right:
//                offset = CGVector(dx: -1.0, dy: 0.0)
//            default:
//                offset = CGVector(dx: 0.0, dy: 0.0)
//            }
//        }
        
        let offToLeftSideFrame = CGRect(x: -1 * fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        let onScreenFrame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        let offToRightSideFrame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        
        if goingToMusicSearch {
            // For a presentation, the toView starts off-screen and slides in.
            fromView.frame = onScreenFrame // cam
            toView.frame = offToLeftSideFrame // music

            
            // addSubview places it's argument at the fron of the subview stack. For dismissal animation we want the fromView to slide away, revealing the toView. Therefor we must place the toView under the fromView.
            containerView.insertSubview(toView, belowSubview: fromView)
        } else {
            fromView.frame = onScreenFrame // music
            toView.frame = offToRightSideFrame // cam
            
            containerView.addSubview(toView)
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 

            if goingToMusicSearch {
                fromView.frame = offToRightSideFrame // cam
                toView.frame = onScreenFrame // music
            } else {
                fromView.frame = offToLeftSideFrame // music
                toView.frame = onScreenFrame // came

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
