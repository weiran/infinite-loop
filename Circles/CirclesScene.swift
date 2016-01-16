//
//  CirclesScene.swift
//  Circles
//
//  Created by Weiran Zhang on 15/11/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

import SpriteKit
import GCHelper

class CirclesScene: SKScene, SKPhysicsContactDelegate {
    var parentViewController : UIViewController?
    
    let radius : CGFloat = 180
    let width : CGFloat = 12
    let circleSize = 20
    
    private var targetCircle : SKShapeNode?
    private var aimCircle : SKShapeNode?
    private var scoreLabel : SKLabelNode?
    
    var colliding = false
    var duration = 1.0
    var level = 0
    var score = 0 {
        didSet {
            scoreLabel?.text = "\(score)"            
            switch score {
                case 0...4: level = 0
                case 5...9: level = 1
                case 10...14: level = 2
                case 15...19: level = 3
                case 20...29: level = 4
                default: level = 5
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        configureBackgroundGradient()
        configureBackgroundCircle()
        configureTargetCircle()
        configureAimCircle()
        configureScoreLabel()
        
        self.physicsWorld.contactDelegate = self
    }
    
    func configureBackgroundGradient() {
        let colour1 = UIColor(red:0.215, green:0.609, blue:0.976, alpha:1)
        let colour2 = UIColor(red:0.759, green:0.225, blue:0.985, alpha:1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [colour1, colour2].map { $0.CGColor }
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
    
    private func configureBackgroundCircle() {
        let backgroundCircle = SKShapeNode(circleOfRadius: radius)
        backgroundCircle.position = CGPointMake(frame.midX, frame.midY)
        backgroundCircle.strokeColor = SKColor.whiteColor()
        backgroundCircle.lineWidth = width
        backgroundCircle.fillColor = SKColor.clearColor()
        self.addChild(backgroundCircle)
    }
    
    private func configureTargetCircle() {
        var maxTargetSize = 160
        var minTargetSize = 120
        let difficultyFactor = 20
        
        maxTargetSize = maxTargetSize - (difficultyFactor * level)
        minTargetSize = minTargetSize - (difficultyFactor * level)
        
        let targetStartDegrees = Int.random(0...270)
        let maxEndDegrees = targetStartDegrees + maxTargetSize
        let minEndDegrees = targetStartDegrees + minTargetSize
        
        var targetEndDegrees = Int.random(targetStartDegrees...maxEndDegrees)
        if targetEndDegrees < minEndDegrees {
            targetEndDegrees = minEndDegrees
        }
        
        let targetStartAngle = targetStartDegrees.degreesToRadians
        let targetEndAngle = targetEndDegrees.degreesToRadians
        let targetSemiCirclePath = UIBezierPath(arcCenter: CGPointZero, radius: radius, startAngle: targetStartAngle, endAngle: targetEndAngle, clockwise: true)
        
        if targetCircle == nil {
            let targetCircle = SKShapeNode(path: targetSemiCirclePath.CGPath)
            targetCircle.position = CGPointMake(frame.midX, frame.midY)
            targetCircle.strokeColor = SKColor.purpleColor()
            targetCircle.lineWidth = width
            targetCircle.fillColor = SKColor.clearColor()
            
            self.addChild(targetCircle)
            self.targetCircle = targetCircle
        }
        
        targetCircle?.path = targetSemiCirclePath.CGPath
        
        let targetCirclePhysicsBody = SKPhysicsBody(polygonFromPath: targetCircle!.path!)
        targetCirclePhysicsBody.affectedByGravity = false
        targetCirclePhysicsBody.categoryBitMask = SceneNodes.TargetCircle
        targetCirclePhysicsBody.collisionBitMask = 0
        targetCirclePhysicsBody.contactTestBitMask = SceneNodes.AimCircle
        targetCircle?.physicsBody = targetCirclePhysicsBody
    }
    
    private func configureAimCircle() {
        let aimStartAngle = 0.degreesToRadians
        let aimEndAngle = circleSize.degreesToRadians
        let aimCirclePath = UIBezierPath(arcCenter: CGPointZero, radius: radius, startAngle: aimStartAngle, endAngle: aimEndAngle, clockwise: true)
        
        if (aimCircle == nil) {
            let aimCircle = SKShapeNode(path: aimCirclePath.CGPath)
            aimCircle.position = CGPointMake(frame.midX, frame.midY)
            aimCircle.strokeColor = SKColor.redColor()
            aimCircle.lineWidth = width
            aimCircle.fillColor = SKColor.clearColor()
            
            self.addChild(aimCircle)
            self.aimCircle = aimCircle
        }
        
        let moveAimAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        let repeatAction = SKAction.repeatActionForever(moveAimAction)
        aimCircle?.runAction(repeatAction)
        
        let aimCirclePhysicsBody = SKPhysicsBody(polygonFromPath: aimCirclePath.CGPath)
        aimCirclePhysicsBody.affectedByGravity = false
        aimCirclePhysicsBody.categoryBitMask = SceneNodes.AimCircle
        aimCirclePhysicsBody.collisionBitMask = 0
        aimCirclePhysicsBody.contactTestBitMask = SceneNodes.TargetCircle
        aimCircle?.physicsBody = aimCirclePhysicsBody
    }
    
    private func configureScoreLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(frame.midX, frame.midY - 10)
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 64
        scoreLabel.fontName = "SanFranciscoDisplay-Bold"
        
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        colliding = true
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        colliding = false
    }
    
    func reset() {
        self.score = 0
        colliding = false
        level = 0
        configureAimCircle()
        configureTargetCircle()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for _ in touches {
            if colliding {
                score++
                print("Hit score: \(score)")
                configureTargetCircle()
                colliding = false
                
                duration = duration * 0.95
                if let aimCircle = aimCircle {
                    let moveAimAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:duration)
                    let repeatAction = SKAction.repeatActionForever(moveAimAction)
                    aimCircle.removeAllActions()
                    aimCircle.runAction(repeatAction)
                }
            } else {
                duration = 1 // reset duration
                print("Miss")
                aimCircle?.removeAllActions()
                GCHelper.sharedInstance.reportLeaderboardIdentifier("TopScore", score: score)
                
                let failedAlert = UIAlertController(title: "Missed", message: "Your top score is \(score)", preferredStyle: .Alert)
                failedAlert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { (_) -> Void in
                    self.reset()
                }))
                self.parentViewController?.presentViewController(failedAlert, animated: true, completion: nil)
            }
        }
    }
}

struct SceneNodes {
    static let AimCircle : UInt32 = (1 << 0)
    static let TargetCircle : UInt32 = (1 << 1)
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
    
    static func random(range: Range<Int>) -> Int {
        var offset = 0
        
        if range.startIndex < 0 { // allow negative ranges
            offset = abs(range.startIndex)
        }
        
        let min = UInt32(range.startIndex + offset)
        let max = UInt32(range.endIndex + offset)
        
        return Int(min + arc4random_uniform(max - min)) - offset
    }
}