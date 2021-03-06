//
//  ResultsScene.swift
//  Circles iOS
//
//  Created by Weiran Zhang on 24/01/2016.
//  Copyright © 2016 Weiran Zhang. All rights reserved.
//

import SpriteKit

class ResultsScene: SKScene {
    let radius : CGFloat = 180
    let width : CGFloat = 12
    let circleSize = 20
    
    var score: Int?
    var topScore: Int?
    
    var retryButton: SKLabelNode?
    var leaderboardButton: SKSpriteNode?
    var backgroundCircle: SKShapeNode?
    
    var gameScene: GameScene?
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureBackgroundGradient()
        configureBackgroundCircle()
        configureScoreLabel()
        configureTopScoreLabel()
        configureRetryButton()
        configureLeaderboardButton()
        
        gameViewController?.authenticateGameCentre(showPrompt: false)
    }
    
    fileprivate func configureBackgroundGradient() {
        let colour1 = UIColor(white: 0.2, alpha: 1)
        let colour2 = UIColor(white: 0.7, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [colour2, colour1].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // render the gradient to a UIImage
        UIGraphicsBeginImageContext(frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let node = SKSpriteNode(texture: SKTexture(image: image!));
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.zPosition = -1 // behind everything
        self.addChild(node)
    }
    
    fileprivate func configureScoreLabel() {
        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        scoreLabel.text = String(score!)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 64
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - (scoreLabel.frame.size.height / 2))
        
        self.addChild(scoreLabel)
    }
    
    fileprivate func configureBackgroundCircle() {
        let backgroundCircle = SKShapeNode(circleOfRadius: radius)
        backgroundCircle.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundCircle.strokeColor = SKColor.white
        backgroundCircle.lineWidth = width
        backgroundCircle.fillColor = SKColor.clear
        self.backgroundCircle = backgroundCircle
        
        self.addChild(backgroundCircle)
    }
    
    fileprivate func configureTopScoreLabel() {
        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        scoreLabel.text = topScore == nil ? "0" : String(topScore!)
        scoreLabel.position = CGPoint(x: frame.midX, y: backgroundCircle!.position.y + radius + 80)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 32
        
        self.addChild(scoreLabel)
    }
    
    fileprivate func configureLeaderboardButton() {
        let leaderboardButton = SKSpriteNode(imageNamed: "LeaderboardIcon")
        leaderboardButton.position = CGPoint(x: frame.midX, y: backgroundCircle!.position.y + radius + 140)
        leaderboardButton.size = CGSize(width: 40, height: 40)
        
        let pulseUp = SKAction.scale(to: 1.05, duration: 0.3)
        let pulseDown = SKAction.scale(to: 0.95, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        leaderboardButton.run(repeatPulse)
        
        self.leaderboardButton = leaderboardButton
        
        self.addChild(leaderboardButton)
    }
    
    fileprivate func configureRetryButton() {
        let retryButton = SKLabelNode(fontNamed: "AvenirNext-Regular")
        retryButton.text = "Retry"
        retryButton.position = CGPoint(x: frame.midX, y: backgroundCircle!.position.y - radius - 130)
        retryButton.fontColor = SKColor.white
        retryButton.fontSize = 32
        retryButton.name = "retryButton"
        
        let pulseUp = SKAction.scale(to: 1.05, duration: 0.3)
        let pulseDown = SKAction.scale(to: 0.95, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        retryButton.run(repeatPulse)
        
        self.retryButton = retryButton
        
        self.addChild(retryButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if self.atPoint(location) == self.retryButton {
                gameScene?.reset()
                scene?.view?.presentScene(gameScene!, transition: SKTransition.doorway(withDuration: 0.3))
            } else if self.atPoint(location) == self.leaderboardButton {
                gameViewController?.showGameCentreLeaderboard()
            }
        }
    }
}
