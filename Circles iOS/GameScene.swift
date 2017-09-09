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
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // get current top score
        let topScore = UserDefaults.standard.integer(forKey: "TopScore")
        self.leaderboardTopScore = topScore
        
        getLeaderboardTopScore()
    }
    
    override func playerDidFail(_ score: Int) {
        super.playerDidFail(score)
        
        // report score
        let scoreObject = GKScore(leaderboardIdentifier: "CirclesTopScore")
        scoreObject.value = Int64(score)
        GKScore.report([scoreObject], withCompletionHandler: { (error) -> Void in
            if let error = error {
                print("Error in reporting leaderboard scores: \(error)")
            }
        }) 
        
        let topScore = max(score, leaderboardTopScore)
        UserDefaults.standard.set(topScore, forKey: "TopScore")
        
        if let resultsScene = ResultsScene(fileNamed: "ResultsScene") {
            resultsScene.score = score
            resultsScene.topScore = topScore
            resultsScene.gameScene = self
            resultsScene.scaleMode = .aspectFill
            resultsScene.gameViewController = gameViewController
            scene?.view?.presentScene(resultsScene, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
    
    fileprivate func getLeaderboardTopScore() {
        let leaderboardRequest = GKLeaderboard()
        leaderboardRequest.identifier = "CirclesTopScore"
        leaderboardRequest.loadScores(completionHandler: { (scores, error) in
            if let topScore = leaderboardRequest.localPlayerScore?.value {
                self.leaderboardTopScore = max(self.leaderboardTopScore, Int(topScore))
            }
        })
    }
}
