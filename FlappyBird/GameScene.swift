//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let verticalPipeGap = 150.0
    
    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    
    override func didMoveToView(view: SKView) {
        // setup physics
        physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        
        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        backgroundColor = skyColor
        
        // ground
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .Nearest
        
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
        
        for var i:CGFloat = 0; i < 2.0 + frame.size.width / ( groundTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            addChild(sprite)
        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite, resetSkySprite]))
        
        for var i:CGFloat = 0; i < 2.0 + frame.size.width / ( skyTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.runAction(moveSkySpritesForever)
            addChild(sprite)
        }
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.runBlock( spawnPipes )
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        runAction(spawnThenDelayForever)
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = .Nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = .Nearest
        
        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatActionForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: frame.size.width * 0.35, y:frame.size.height * 0.6)
        bird.runAction(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody.dynamic = true
        bird.physicsBody.allowsRotation = false
        
        addChild(bird)
        
        // create the ground
        let ground = SKNode()
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(frame.size.width, groundTexture.size().height * 2.0))
        ground.physicsBody.dynamic = false
        addChild(ground)
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake( frame.size.width + pipeTextureUp.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( frame.size.height / 4 )
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(verticalPipeGap))
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody.dynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody.dynamic = false
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(movePipesAndRemove)
        addChild(pipePair)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode?(self)
            
            bird.physicsBody.velocity = CGVectorMake(0, 0)
            bird.physicsBody.applyImpulse(CGVectorMake(0, 30))
        }
    }
    
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bird.zRotation = clamp( -1, max: 0.5, value: bird.physicsBody.velocity.dy * ( bird.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
}
