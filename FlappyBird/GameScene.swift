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
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
   
    override func didMoveToView(view: SKView) {
        
        setupPhysics()
        setupBackground()
        let groundTexture = setupGround()
        setupSkyline(groundTexture)
        setupPipes()
        setupBird()
        
        initGround(groundTexture);
    }
    
    func setupPhysics() {
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
    }
    
    func setupBackground() {
        self.backgroundColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    }
    
    func prepareTexture(imageName: String, durationMulitplier: Float, spritePositioner: (CGFloat, SKSpriteNode) -> ()) -> SKTexture {
        let texture = SKTexture(imageNamed: imageName)
        texture.filteringMode = SKTextureFilteringMode.Nearest
        
        let moveSprite = SKAction.moveByX(-texture.size().width * 2.0, y: 0, duration: NSTimeInterval(durationMulitplier * texture.size().width * 2.0))
        let resetSprite = SKAction.moveByX(texture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSprite,resetSprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( texture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: texture)
            sprite.setScale(2.0)
            
            spritePositioner(i, sprite)
            
            sprite.runAction(moveSpritesForever)
            self.addChild(sprite)
        }
        
        return texture;
    }
    
    func setupGround() -> SKTexture {
        return prepareTexture("land", durationMulitplier: 0.02) {
            (let i, let sprite) -> () in
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0)
        }
    }
    
    func setupSkyline(groundTexture: SKTexture) -> SKTexture {
        return prepareTexture("sky", durationMulitplier: 0.01) {
            (let i, let sprite) -> () in
            sprite.zPosition = -20
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
        }
    }
    
    func setupPipes() {
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = SKTextureFilteringMode.Nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = SKTextureFilteringMode.Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.runBlock(spawnPipes)
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
    }
    
    func setupBird() {
        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = SKTextureFilteringMode.Nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = SKTextureFilteringMode.Nearest
        
        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatActionForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        bird.runAction(flap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody.dynamic = true
        bird.physicsBody.allowsRotation = false
        
        self.addChild(bird)
    }
    
    func initGround(texture : SKTexture) {
        var ground = SKNode()
        ground.position = CGPointMake(0, texture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, texture.size().height * 2.0))
        ground.physicsBody.dynamic = false
        self.addChild(ground)
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake( self.frame.size.width + pipeTextureUp.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( self.frame.size.height / 4 )
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
        self.addChild(pipePair)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            bird.physicsBody.velocity = CGVectorMake(0, 0)
            bird.physicsBody.applyImpulse(CGVectorMake(0, 30))
            
        }
    }
    
    // TODO: Move to utilities somewhere. There's no reason this should be a member function
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
        bird.zRotation = self.clamp( -1, max: 0.5, value: bird.physicsBody.velocity.dy * ( bird.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
}
