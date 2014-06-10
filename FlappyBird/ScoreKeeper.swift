//
//  ScoreKeeper.swift
//  FlappyBird
//
//  Created by Gregor Karzelek on 10.06.14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class ScoreKeeper {
    
    let highlightAction = SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))])
    
    var scoreLabelNode:SKLabelNode!
    var score = 0
    
    init() {
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
    }
    
    func increment() {
        increment(by: 1)
        updateVisualization()
    }
    
    func increment(by scoreIncrement: Int) {
        score += scoreIncrement
    }
    
    func reset() {
        score = 0
        updateVisualization()
    }
    
    func setupVisualization(atXY xyPosition: CGPoint,  andZ zPosition: CGFloat) -> SKNode {
        scoreLabelNode.position = xyPosition
        scoreLabelNode.zPosition = zPosition
        scoreLabelNode.text = String(score)
        
        return scoreLabelNode
    }
    
    func updateVisualization() {
        scoreLabelNode.text = String(score)
        
        scoreLabelNode.runAction(highlightAction)
    }
}