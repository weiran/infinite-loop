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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        configureBackgroundGradient()
        configureBackgroundCircle()
        configureScoreLabel()
        configureTopScoreDescriptionLabel()
        configureTopScoreLabel()
        configureRetryButton()
    }
    
    private func configureBackgroundGradient() {
//        let colour1 = UIColor(red:0.215, green:0.609, blue:0.976, alpha:1)
//        let colour2 = UIColor(red:0.759, green:0.225, blue:0.985, alpha:1)
        let colour1 = UIColor(white: 0.2, alpha: 1)
        let colour2 = UIColor(white: 0.7, alpha: 1)

        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [colour2, colour1].map { $0.CGColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // render the gradient to a UIImage
        UIGraphicsBeginImageContext(frame.size)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let node = SKSpriteNode(texture: SKTexture(image: image));
        node.position = CGPointMake(frame.midX, frame.midY)
        node.zPosition = -1 // behind everything
        self.addChild(node)
    }
    
    private func configureScoreLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = String(score!)
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 64
        scoreLabel.fontName = "SanFranciscoDisplay-Bold"
        scoreLabel.position = CGPointMake(frame.midX, frame.midY - (scoreLabel.frame.size.height / 2))
        
        self.addChild(scoreLabel)
    }
    
    private func configureBackgroundCircle() {
        let backgroundCircle = SKShapeNode(circleOfRadius: radius)
        backgroundCircle.position = CGPointMake(frame.midX, frame.midY)
        backgroundCircle.strokeColor = SKColor.whiteColor()
        backgroundCircle.lineWidth = width
        backgroundCircle.fillColor = SKColor.clearColor()
        self.backgroundCircle = backgroundCircle
        
        self.addChild(backgroundCircle)
    }
    
    private func configureTopScoreDescriptionLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "Top Score"
        scoreLabel.position = CGPointMake(frame.midX, backgroundCircle!.position.y + radius + 130)
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "SanFranciscoDisplay-Normal"
        
        self.addChild(scoreLabel)
    }
    
    private func configureTopScoreLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = topScore == nil ? "0" : String(topScore!)
        scoreLabel.position = CGPointMake(frame.midX, backgroundCircle!.position.y + radius + 80)
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 32
        scoreLabel.fontName = "SanFranciscoDisplay-Bold"
        
        self.addChild(scoreLabel)
    }
    
    private func configureRetryButton() {
        let retryButton = SKLabelNode()
        retryButton.text = "Retry"
        retryButton.position = CGPointMake(frame.midX, backgroundCircle!.position.y - radius - 130)
        retryButton.fontColor = SKColor.whiteColor()
        retryButton.fontSize = 32
        retryButton.fontName = "SanFranciscoDisplay-Bold"
        retryButton.name = "retryButton"
        
        let pulseUp = SKAction.scaleTo(1.05, duration: 0.3)
        let pulseDown = SKAction.scaleTo(0.95, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        retryButton.runAction(repeatPulse)
        
        self.retryButton = retryButton
        
        self.addChild(retryButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.retryButton {
                gameScene?.reset()
                scene?.view?.presentScene(gameScene!, transition: SKTransition.doorwayWithDuration(0.3))
            }
        }
    }
}
