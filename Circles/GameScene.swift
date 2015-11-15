//
//  GameScene.swift
//  Circles
//
//  Created by Weiran Zhang on 14/11/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

import SpriteKit

class GameScene: CirclesScene {
    override func didMoveToView(view: SKView) {
        scoreLabelX = 140
        scoreLabelY = frame.midY
        super.didMoveToView(view)
    }
}