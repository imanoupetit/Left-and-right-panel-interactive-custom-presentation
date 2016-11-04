//
//  LeftPresentationController.swift
//  RightPanelProject
//
//  Created by Imanou Petit on 26/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import UIKit

class LeftPresentationController: UIPresentationController {
    
    let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        // Set dimming view transparency
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Add a tap gesture recognizer for dimming view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            presentedViewController.performSegue(withIdentifier: "HideSettings", sender: sender)
        }
    }
    
    // The frame rectangle to assign to the presented view at the end of the animations
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = containerView?.bounds else { fatalError() }
        
        let presentedViewSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        let presentedViewOrigin = CGPoint(x: 0, y: CGSize.zero.height)
        return CGRect(origin: presentedViewOrigin, size: presentedViewSize)
    }
    
    override func containerViewWillLayoutSubviews() {
        // Before layout, make sure our dimmingView and presentedView have the correct frame
        // called when collectionTraits change
        dimmingView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        // We always want a size that's a 7/10th of our container width, and just as tall as the container
        return CGSize(width: parentSize.width / 10 * 7, height: parentSize.height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        dimmingView.alpha = 0.0
        containerView?.addSubview(dimmingView)
        
        let transition: (UIViewControllerTransitionCoordinatorContext!) -> Void = { _ in self.dimmingView.alpha = 1.0 }
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: transition, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        let transition: (UIViewControllerTransitionCoordinatorContext!) -> Void = { _ in self.dimmingView.alpha = 0.0 }
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: transition, completion: nil)
    }
    
}
