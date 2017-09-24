//
//  CirclesScene.swift
//  Circles
//
//  Created by Weiran Zhang on 15/11/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

import SpriteKit

class CirclesScene: SKScene, SKPhysicsContactDelegate {
    var parentViewController : UIViewController?
    
    let radius : CGFloat = 180
    let width : CGFloat = 12
    let circleSize = 20
    
    fileprivate var targetCircle : SKShapeNode?
    fileprivate var aimCircle : SKShapeNode?
    fileprivate var scoreLabel : SKLabelNode?
    fileprivate var bounceAction = SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1, duration: 0.3)])
    
    var isSceneConfigured = false
    var colliding = false
    var duration = 1.0
    var level = 0
    var score = 0 {
        didSet {
            scoreLabel?.text = "\(score)"
            scoreLabel?.run(bounceAction)
            
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
    var leaderboardTopScore = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view);
        
        if isSceneConfigured == false {
            configureBackgroundGradient()
            configureBackgroundCircle()
            configureTargetCircle()
            configureAimCircle()
            configureScoreLabel()
            
            self.physicsWorld.contactDelegate = self
            isSceneConfigured = true
        }
    }
    
    fileprivate func configureBackgroundGradient() {
        let colour1 = UIColor(red:0.215, green:0.609, blue:0.976, alpha:1)
        let colour2 = UIColor(red:0.759, green:0.225, blue:0.985, alpha:1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [colour1, colour2].map { $0.cgColor }
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
    
    fileprivate func configureBackgroundCircle() {
        let backgroundCircle = SKShapeNode(circleOfRadius: radius)
        backgroundCircle.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundCircle.strokeColor = SKColor.white
        backgroundCircle.lineWidth = width
        backgroundCircle.fillColor = SKColor.clear
        self.addChild(backgroundCircle)
    }
    
    fileprivate func configureTargetCircle() {
        var maxTargetSize = 160
        var minTargetSize = 120
        let difficultyFactor = 20
        
        maxTargetSize = maxTargetSize - (difficultyFactor * level)
        minTargetSize = minTargetSize - (difficultyFactor * level)
        
        let targetStartDegrees = Int.random(Range(0...270))
        let maxEndDegrees = targetStartDegrees + maxTargetSize
        let minEndDegrees = targetStartDegrees + minTargetSize
        
        var targetEndDegrees = Int.random(Range(targetStartDegrees...maxEndDegrees))
        if targetEndDegrees < minEndDegrees {
            targetEndDegrees = minEndDegrees
        }
        
        let targetStartAngle = targetStartDegrees.degreesToRadians
        let targetEndAngle = targetEndDegrees.degreesToRadians
        let targetSemiCirclePath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: targetStartAngle, endAngle: targetEndAngle, clockwise: true)
        
        if targetCircle == nil {
            let targetCircle = SKShapeNode(path: targetSemiCirclePath.cgPath)
            targetCircle.position = CGPoint(x: frame.midX, y: frame.midY)
            targetCircle.strokeColor = SKColor.purple
            targetCircle.lineWidth = width
            targetCircle.fillColor = SKColor.clear
            
            self.addChild(targetCircle)
            self.targetCircle = targetCircle
        }
        
        targetCircle?.path = targetSemiCirclePath.cgPath
        
        let targetCirclePhysicsBody = SKPhysicsBody(polygonFrom: targetCircle!.path!)
        targetCirclePhysicsBody.affectedByGravity = false
        targetCirclePhysicsBody.categoryBitMask = SceneNodes.TargetCircle
        targetCirclePhysicsBody.collisionBitMask = 0
        targetCirclePhysicsBody.contactTestBitMask = SceneNodes.AimCircle
        targetCircle?.physicsBody = targetCirclePhysicsBody
    }
    
    fileprivate func configureAimCircle() {
        let aimStartAngle = 0.degreesToRadians
        let aimEndAngle = circleSize.degreesToRadians
        let aimCirclePath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: aimStartAngle, endAngle: aimEndAngle, clockwise: true)
        
        if (aimCircle == nil) {
            let aimCircle = SKShapeNode(path: aimCirclePath.cgPath)
            aimCircle.position = CGPoint(x: frame.midX, y: frame.midY)
            aimCircle.strokeColor = SKColor.red
            aimCircle.lineWidth = width
            aimCircle.fillColor = SKColor.clear
            
            self.addChild(aimCircle)
            self.aimCircle = aimCircle
        }
        
        let moveAimAction = SKAction.rotate(byAngle: .pi, duration: 1)
        let repeatAction = SKAction.repeatForever(moveAimAction)
        aimCircle?.run(repeatAction)
        
        let aimCirclePhysicsBody = SKPhysicsBody(polygonFrom: aimCirclePath.cgPath)
        aimCirclePhysicsBody.affectedByGravity = false
        aimCirclePhysicsBody.categoryBitMask = SceneNodes.AimCircle
        aimCirclePhysicsBody.collisionBitMask = 0
        aimCirclePhysicsBody.contactTestBitMask = SceneNodes.TargetCircle
        aimCircle?.physicsBody = aimCirclePhysicsBody
    }
    
    fileprivate func configureScoreLabel() {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "0"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 64
        scoreLabel.fontName = UIFont.systemFont(ofSize: 64).fontName
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - (scoreLabel.frame.size.height / 2))
        
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        colliding = true
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        colliding = false
    }
    
    func reset() {
        self.score = 0
        colliding = false
        level = 0
        configureAimCircle()
        configureTargetCircle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerDidSucceed()
        
        for _ in touches {
            if colliding {
                score += 1
                configureTargetCircle()
                colliding = false
                
                duration = duration * 0.95
                if let aimCircle = aimCircle {
                    let moveAimAction = SKAction.rotate(byAngle: .pi, duration:duration)
                    let repeatAction = SKAction.repeatForever(moveAimAction)
                    aimCircle.removeAllActions()
                    aimCircle.run(repeatAction)
                }
            } else {
                duration = 1 // reset duration
                aimCircle?.removeAllActions()
                playerDidFail(score)
            }
        }
    }
    
    func playerDidFail(_ score: Int) { }
    
    func playerDidSucceed() { }
}

struct SceneNodes {
    static let AimCircle : UInt32 = (1 << 0)
    static let TargetCircle : UInt32 = (1 << 1)
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
    
    static func random(_ range: Range<Int>) -> Int {
        var offset = 0
        
        if range.lowerBound < 0 { // allow negative ranges
            offset = abs(range.lowerBound)
        }
        
        let min = UInt32(range.lowerBound + offset)
        let max = UInt32(range.upperBound + offset)
        
        return Int(min + arc4random_uniform(max - min)) - offset
    }
}
