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
    var backgroundCircle: SKShapeNode?
    
    var gameScene: GameScene?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureBackgroundGradient()
        configureBackgroundCircle()
        configureScoreLabel()
        configureTopScoreDescriptionLabel()
        configureTopScoreLabel()
        configureRetryButton()
    }
    
    fileprivate func configureBackgroundGradient() {
//        let colour1 = UIColor(red:0.215, green:0.609, blue:0.976, alpha:1)
//        let colour2 = UIColor(red:0.759, green:0.225, blue:0.985, alpha:1)
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
        let scoreLabel = SKLabelNode()
        scoreLabel.text = String(score!)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 64
        scoreLabel.fontName = "SanFranciscoDisplay-Bold"
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
    
    fileprivate func configureTopScoreDescriptionLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "Top Score"
        scoreLabel.position = CGPoint(x: frame.midX, y: backgroundCircle!.position.y + radius + 130)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "SanFranciscoDisplay-Normal"
        
        self.addChild(scoreLabel)
    }
    
    fileprivate func configureTopScoreLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = topScore == nil ? "0" : String(topScore!)
        scoreLabel.position = CGPoint(x: frame.midX, y: backgroundCircle!.position.y + radius + 80)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 32
        scoreLabel.fontName = "SanFranciscoDisplay-Bold"
        
        self.addChild(scoreLabel)
    }
    
    fileprivate func configureRetryButton() {
        let retryButton = SKLabelNode()
        retryButton.text = "Retry"
        retryButton.position = CGPoint(x: frame.midX, y: backgroundCircle!.position.y - radius - 130)
        retryButton.fontColor = SKColor.white
        retryButton.fontSize = 32
        retryButton.fontName = "SanFranciscoDisplay-Bold"
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
            }
        }
    }
}
