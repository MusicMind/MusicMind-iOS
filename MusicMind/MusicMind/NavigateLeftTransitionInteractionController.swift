//
//  NavigateLeftTransitionInteractionController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/14/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class NavigateLeftTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    func edgeGestureAction(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            print("began")
            
            // if top most VC in stack is MusicSearchVC
            // pop MusicSearchVC off of stack
            // else if currentVC is CameraCaptureVC && user selected the music button
            // performSegue(withIdentifier: showMusicSearchViewContoller, sender: self)
            
        case .cancelled:
            print("cancelled")
        case .changed:
            print("changed")
            self.update(percentForEdgePan(gesture: sender))
        case .ended:
            print("ended")
            self.finish()
        case .failed:
            print("failed")
            self.cancel()
        case .possible:
            print("possible")
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Saving the transition context for later
        self.transitionContext = transitionContext
        
        super.startInteractiveTransition(transitionContext)
    }
    
    private func percentForEdgePan(gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        // Because view controllers will be sliding on and off screen as part
        // of the animation, we want to base our calculations in the coordinate
        // space of the view that will not be moving: the containerView of the
        // transition context.
        let transitionContainerView = transitionContext?.containerView

        let locationInSourceView = gesture.location(in: transitionContainerView)
        
        // Figure out what percentage we've gone.
        
        guard let width = transitionContainerView?.bounds.width else { return 0 }
        
        // Return an appropriate percentage based on which edge we're dragging from.
        let edge = gesture.edges
    
        // Only going to over the left and right edge cases (edge cases, not edge-cases ;)
        switch edge {
        case UIRectEdge.right:
            return (width - locationInSourceView.x) / width
        case UIRectEdge.left:
            return locationInSourceView.x / width
        default:
            return 0.0
        }
    }
}
