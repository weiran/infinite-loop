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
        
        // get current top score
        let topScore = NSUserDefaults.standardUserDefaults().integerForKey("TopScore")
        self.leaderboardTopScore = topScore
        
        getLeaderboardTopScore()
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
        NSUserDefaults.standardUserDefaults().setInteger(topScore, forKey: "TopScore")
        
        if let resultsScene = ResultsScene(fileNamed: "ResultsScene") {
            resultsScene.score = score
            resultsScene.topScore = topScore
            resultsScene.gameScene = self
            resultsScene.scaleMode = .AspectFill
            scene?.view?.presentScene(resultsScene, transition: SKTransition.crossFadeWithDuration(0.3))
        }
    }
    
    private func getLeaderboardTopScore() {
        let leaderboardRequest = GKLeaderboard()
        leaderboardRequest.identifier = "CirclesTopScore"
        leaderboardRequest.loadScoresWithCompletionHandler({ (scores: [GKScore]?, error: NSError?) -> Void in
            if let topScore = leaderboardRequest.localPlayerScore?.value {
                self.leaderboardTopScore = max(self.leaderboardTopScore, Int(topScore))
            }
        })
    }
}