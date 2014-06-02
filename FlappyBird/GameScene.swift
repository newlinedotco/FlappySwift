//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var bird: SKSpriteNode?
    var skyColor: SKColor?
    
    override func didMoveToView(view: SKView) {
        // setup background color
        skyColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        // ground
        var groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        for var i = 0; CGFloat(i) < (2.0 + self.frame.size.width) / ( groundTexture.size().width * 2.0 ); ++i {
            var sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2.0)
            self.addChild(sprite)
        }
        
        // skyline
        var skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        for var i = 0; CGFloat(i) < (2.0 + self.frame.size.width) / ( skyTexture.size().width * 2.0 ); ++i {
            var sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20;
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            self.addChild(sprite)
        }
        
        // setup our bird
        var birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = SKTextureFilteringMode.Nearest
        var birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = SKTextureFilteringMode.Nearest

        var anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        var flap = SKAction.repeatActionForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird!.setScale(2.0)
        bird!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        bird!.runAction(flap)
        self.addChild(bird)
        
        

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
