//
//  SettingsViewController.swift
//  RightPanelProject
//
//  Created by Imanou Petit on 26/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import UIKit

class LeftSettingsViewController: UIViewController {
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Left settings"
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "HideSettings" else { return }
        guard let transitionDelegate = transitioningDelegate as? TransitionDelegate else { return }
        
        // Reset the gestureRecognizer property of the transition delegate according to the sender
        // If there is a sender which is of type UIScreenEdgePanGestureRecognizer, add it and animation will be interactive ; otherwise, animation won't be interactive
        transitionDelegate.gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer
    }
    
}
