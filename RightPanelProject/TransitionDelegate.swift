//
//  TransitionDelegate.swift
//  RightPanelProject
//
//  Created by Imanou Petit on 26/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    let defaultPresentingEdge: UIRectEdge
    let defaultDismissingEdge: UIRectEdge
    let presentationController: UIPresentationController.Type
    
    init(defaultPresentingEdge: UIRectEdge, defaultDismissingEdge: UIRectEdge, presentationController: UIPresentationController.Type) {
        // Set some default edges for the presentation. They will be usefull if gestureRecognizer is nil
        self.defaultPresentingEdge = defaultPresentingEdge
        self.defaultDismissingEdge = defaultDismissingEdge
        // presentationController is of type UIPresentationController.Type and should dynamically be of type RightPresentationController or LeftPresentationController. 
        // We will instantiate it in `presentationController(forPresented:presenting:source:)` with the desired parameters
        self.presentationController = presentationController
        
        super.init()
    }
    
    // MARK: - Getting the Custom Presentation Controller
    
    // Only needed if a subclass of UIPresentationController is implemented
    // We want this here in order to have a dimming view around our presented view controller
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // Will initialize a UIPresentationController subclass, may it be a RightPresentationController or a LeftPresentationController
        return presentationController.init(presentedViewController: presented, presenting: source)
    }
    
    // MARK: - Getting the Transition Animator Objects
    
    // Only needed if a subclass of UIViewControllerAnimatedTransitioning is implemented; otherwise, return nil (default)
    // We want this here in order to have a custom animation or an interactive animation (with gesture)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // If there is no gesture, set an arbitray edge
        let animationController = TransitionAnimator(edgeForDragging: gestureRecognizer?.edges ?? defaultPresentingEdge)
        return animationController
    }

    // The system calls this method on the presented view controller's transitioningDelegate to retrieve the animator object used for animating the dismissal of the presented view controller.
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // If there is no gesture, set an arbitary edge
        let animationController = TransitionAnimator(edgeForDragging: gestureRecognizer?.edges ?? defaultDismissingEdge)
        return animationController
    }
    
    // MARK: - Getting the Interactive Animator Objects
    
    // If a `UIViewControllerAnimatedTransitioning` was returned from `animationControllerForPresentedController(_:, presentingController:, sourceController:)`, the system calls this method to retrieve the interaction controller for the presentation transition. Your implementation is expected to return an object that conforms to the UIViewControllerInteractiveTransitioning protocol, or nil if the transition should not be interactive.
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // You must not return an interaction controller from this method unless the transition is to be be interactive.
        return gestureRecognizer.flatMap(TransitionInteractionController.init(gestureRecognizer:))
    }
    
    // If a `UIViewControllerAnimatedTransitioning` was returned from `animationControllerForDismissedController(_:), the system calls this method to retrieve the interaction controller for the dismissal transition. Your implementation is expected to return an object that conforms to the UIViewControllerInteractiveTransitioning protocol, or nil if the transition should not be interactive.
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // You must not return an interaction controller from this method unless the transition is to be be interactive.
        return gestureRecognizer.flatMap(TransitionInteractionController.init(gestureRecognizer:))
    }

}
