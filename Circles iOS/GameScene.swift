//
//  GameScene.swift
//  Circles
//
//  Created by Weiran Zhang on 14/11/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: CirclesScene {
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
    }
    
    override func playerDidFail(score: Int) {
        super.playerDidFail(score)
        
        // report score
        let scoreObject = GKScore(leaderboardIdentifier: "CirclesTopScore")
        scoreObject.value = Int64(score)
        GKScore.reportScores([scoreObject]) { (error) -> Void in
            if error != nil {
                print("Error in reporting leaderboard scores: \(error)")
            }
        }
        
        let topScore = max(score, leaderboardTopScore)
        let failedAlert = UIAlertController(title: "Missed", message: "Ha Ha.\nYour top score is \(topScore)", preferredStyle: .Alert)
        failedAlert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { (_) -> Void in
            self.reset()
        }))
        
        self.parentViewController?.presentViewController(failedAlert, animated: true, completion: nil)
    }
}