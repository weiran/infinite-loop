//
//  GameViewController.swift
//  Circles iOS
//
//  Created by Weiran Zhang on 15/11/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import StoreKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateGameCentre(showPrompt: false)

        if let scene = GameScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.parentViewController = self
            scene.gameViewController = self
            
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func authenticateGameCentre(showPrompt: Bool = true) {
        GKLocalPlayer.local.authenticateHandler = { (viewController, error) in
            if showPrompt, let viewController = viewController {
                self.present(viewController, animated: true, completion: nil)
            }
            if let error = error {
                print("Game Center Authentication Error: \(error.localizedDescription)")
            }
        }
    }
    
    func showGameCentreLeaderboard() {
        if GKLocalPlayer.local.isAuthenticated {
            let gcViewController = GKGameCenterViewController()
            gcViewController.gameCenterDelegate = self
            gcViewController.viewState = .leaderboards
            gcViewController.leaderboardIdentifier = "CirclesTopScore"
            present(gcViewController, animated: true, completion: nil)
        }
        else {
            let loginAlert = UIAlertController(title: "Game Centre", message: "You need to be signed into Game Centre to view leaderboards.", preferredStyle: .alert)
            loginAlert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { action in
                self.authenticateGameCentre(showPrompt: true)
            }))
            loginAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(loginAlert, animated: true, completion: nil)
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showRatingDialog() {
        let attemptsCount = UserDefaults.standard.integer(forKey: "AttemptsCount")
        if attemptsCount == 5 || attemptsCount == 15 || attemptsCount == 30 {
            SKStoreReviewController.requestReview()
        }
    }
}
