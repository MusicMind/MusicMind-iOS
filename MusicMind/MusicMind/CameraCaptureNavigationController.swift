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
    
    var edgeGesture: UIScreenEdgePanGestureRecognizer?
    
    var interactionController = NavigateLeftTransitionInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gesture recognizer
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: interactionController, action: #selector(edgeGestureAction(sender:)))
        
        if let edgeGesture = edgeGesture {
            edgeGesture.edges = UIRectEdge.left
            
            view.addGestureRecognizer(edgeGesture)
        }
        
        delegate = self
    }
    
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
            
            if let edgeGesture = edgeGesture{
                interactionController.update(percentForEdgePan(gesture: edgeGesture))
            }
            
        case .ended:
            print("ended")
            interactionController.finish()
        case .failed:
            print("failed")
            interactionController.cancel()
        case .possible:
            print("possible")
        }
    }
    
    private func percentForEdgePan(gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        return 0.0
    }
    
//    //| ----------------------------------------------------------------------------
//    //! Returns the offset of the pan gesture recognizer from the edge of the
//    //! screen as a percentage of the transition container view's width or height.
//    //! This is the percent completed for the interactive transition.
//    //
//    - (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture
//    {
//    // Because view controllers will be sliding on and off screen as part
//    // of the animation, we want to base our calculations in the coordinate
//    // space of the view that will not be moving: the containerView of the
//    // transition context.
//    UIView *transitionContainerView = self.transitionContext.containerView;
//    
//    CGPoint locationInSourceView = [gesture locationInView:transitionContainerView];
//    
//    // Figure out what percentage we've gone.
//    
//    CGFloat width = CGRectGetWidth(transitionContainerView.bounds);
//    CGFloat height = CGRectGetHeight(transitionContainerView.bounds);
//    
//    // Return an appropriate percentage based on which edge we're dragging
//    // from.
//    if (self.edge == UIRectEdgeRight)
//    return (width - locationInSourceView.x) / width;
//    else if (self.edge == UIRectEdgeLeft)
//    return locationInSourceView.x / width;
//    else if (self.edge == UIRectEdgeBottom)
//    return (height - locationInSourceView.y) / height;
//    else if (self.edge == UIRectEdgeTop)
//    return locationInSourceView.y / height;
//    else
//    return 0.f;
//    }
//
    
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
