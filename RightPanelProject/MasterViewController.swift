//
//  MasterViewController.swift
//  RightPanelProject
//
//  Created by Imanou Petit on 26/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    // delegate for custom right and left transition segues
    // Initialize a TransitionDelegate instance with non-interactive default presenting and dismissing edges and with a UIPresentationController subclass type
    // TransitionDelegate's gestureRecognizer parameter (for interactive animation) will be set later
    lazy var rightTransitionDelegate = TransitionDelegate(defaultPresentingEdge: .right, defaultDismissingEdge: .left, presentationController: RightPresentationController.self)
    lazy var leftTransitionDelegate = TransitionDelegate(defaultPresentingEdge: .left, defaultDismissingEdge: .right, presentationController: LeftPresentationController.self)
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interactiveRightTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction(_:)))
        interactiveRightTransitionRecognizer.edges = .right
        view.addGestureRecognizer(interactiveRightTransitionRecognizer)
 
        let interactiveLeftTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction(_:)))
        interactiveLeftTransitionRecognizer.edges = .left
        view.addGestureRecognizer(interactiveLeftTransitionRecognizer)
    }
    
    // MARK: - UIGestureRecognizer selector

    @objc func interactiveTransitionRecognizerAction(_ sender: UIScreenEdgePanGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // perform a segue according to the sender's acceptable edge
        switch sender.edges {
        case [.right]:
            performSegue(withIdentifier: "ShowRightSettings", sender: sender)
        case [.left]:
            performSegue(withIdentifier: "ShowLeftSettings", sender: sender)
        default:
            fatalError("Management for top and bottom screen edges is not implemented")
        }
    }
    
    // MARK: - User interaction
    
    /**
     This IBOutlet acts as the receiver for the HideSettings unwind segue
     */
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        // This method allows the system to perform an unwind segue from SettingsViewController to this viewController
        // No implementation needed
    }
    
    @IBAction func showRightSettings(_ sender: UIBarButtonItem) {
        // Perform non interactive segue to next view controller from bar button item
        performSegue(withIdentifier: "ShowRightSettings", sender: nil)
    }

    @IBAction func showLeftSettings(_ sender: UIBarButtonItem) {
        // Perform non interactive segue to next view controller from bar button item
        performSegue(withIdentifier: "ShowLeftSettings", sender: nil)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("ShowRightSettings"):
            // (Re)set the gestureRecognizer property of the transition delegate according to the sender
            // If sender is of type UIScreenEdgePanGestureRecognizer, add it as a property of transitionDelegate and animation will be interactive ; otherwise, animation won't be interactive
            rightTransitionDelegate.gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer

            let settingsViewController = segue.destination as! RightSettingsViewController
            settingsViewController.transitioningDelegate = rightTransitionDelegate
            settingsViewController.modalPresentationStyle = .custom
        case .some("ShowLeftSettings"):
            // (Re)set the gestureRecognizer property of the transition delegate according to the sender
            // If sender is of type UIScreenEdgePanGestureRecognizer, add it as a property of transitionDelegate and animation will be interactive ; otherwise, animation won't be interactive
            leftTransitionDelegate.gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer

            let settingsViewController = segue.destination as! LeftSettingsViewController
            settingsViewController.transitioningDelegate = leftTransitionDelegate
            settingsViewController.modalPresentationStyle = .custom   
        default:
            break
        }
    }
    
}
