//
//  ViewController.swift
//  Ascendant
//
//  Created by Kyle Bashour on 2/22/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import ElegantPresentations

class WelcomeViewController: UIViewController, Themable, UIViewControllerTransitioningDelegate {

    
    // MARK: - Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var separatorView: UIView!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var startGameButton: AscendantButton!
    @IBOutlet var joinGameButton: AscendantButton!
    @IBOutlet var rulesButton: AscendantButton!
    @IBOutlet var settingsButton: AscendantButton!
    @IBOutlet var rocketImageView: UIImageView!
    @IBOutlet weak var moonImageView: UIImageView!
    
    var rocketDidAnimate = false
    
    
    // MARK: — Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTheme()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateRocket()
    }
    
    
    // MARK: - Style
    
    // Set all the views colors
    func updateTheme() {
        
        view.backgroundColor = Theme.asc_baseColor()
        
        titleLabel.textColor = Theme.asc_defaultTextColor().colorWithAlphaComponent(0.9)
        
        separatorView.backgroundColor = Theme.asc_separatorColor()
        
        subTitleLabel.textColor = Theme.asc_defaultTextColor()
        
        [startGameButton, joinGameButton, rulesButton, settingsButton].forEach {
            $0.backgroundColor = Theme.asc_transparentColor()
            $0.setTitleColor(Theme.asc_buttonTextColor(), forState: .Normal)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return Theme.asc_statusBarStyle()
    }
    
    func animateRocket() {
        
        guard !rocketDidAnimate else {
            return
        }
        
        rocketDidAnimate = true
        
        UIView.animateWithDuration(0.7, delay: 1, options: [.CurveEaseIn],
            animations: {
            
                let x = self.view.frame.width + self.rocketImageView.frame.width
                let y = -self.rocketImageView.frame.height
            
                self.rocketImageView.layer.position = CGPoint(x: x, y: y)
                self.rocketImageView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
                self.moonImageView.alpha = 0
            },
            completion: { _ in
                self.rocketImageView.removeFromSuperview()
                self.moonImageView.removeFromSuperview()
            }
        )
    }
    
    
    // MARK: - Navigation
    
    // Set these for the custom presentation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != R.segue.welcomeViewController.settingsSegue.identifier {
            segue.destinationViewController.modalPresentationStyle = .Custom
            segue.destinationViewController.transitioningDelegate = self
        }
    }
    
    // Unwind segue, also dismiss the keyboard
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) {
        segue.sourceViewController.view.endEditing(true)
        Socket.manager.leaveGame()
    }
    
    // Conform to UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return ElegantPresentations.controller(presentedViewController: presented, presentingViewController: presenting, options: [])
    }
}
