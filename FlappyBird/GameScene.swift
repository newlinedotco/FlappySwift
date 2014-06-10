//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let verticalPipeGap = 150.0
    
    let normalSkyColor =  SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    let errorSkyColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
    
    let score = ScoreKeeper()

    var bird:SKSpriteNode!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = false
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
   
    override func didMoveToView(view: SKView) {
        canRestart = false

        setupPhysics()
        setupBackground()
        let groundTexture = setupGround()
        setupSkyline(groundTexture)
        setupPipes()
        setupBird()
        setupScores()
        
        initGround(groundTexture);
    }
    
    func setupPhysics() {
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
    }
    
    func setupBackground() {
        self.backgroundColor = normalSkyColor
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

        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
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

        bird.physicsBody.categoryBitMask = birdCategory
        bird.physicsBody.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
    }
    
    func initGround(texture : SKTexture) {
        var ground = SKNode()
        ground.position = CGPointMake(0, texture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, texture.size().height * 2.0))
        ground.physicsBody.dynamic = false
        ground.physicsBody.categoryBitMask = worldCategory
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
        pipeDown.physicsBody.categoryBitMask = pipeCategory
        pipeDown.physicsBody.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody.dynamic = false
        pipeUp.physicsBody.categoryBitMask = pipeCategory
        pipeUp.physicsBody.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        contactNode.position = CGPointMake( pipeDown.size.width + bird.size.width / 2, CGRectGetMidY( self.frame ) )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        contactNode.physicsBody.dynamic = false
        contactNode.physicsBody.categoryBitMask = scoreCategory
        contactNode.physicsBody.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
    }

    func setupScores() {
        score.reset()
        self.addChild(score.setupVisualization(atXY: CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 ), andZ: 100))
    }
    
    func resetScene (){
        // Move bird to original position and reset velocity
        bird.position = CGPointMake(self.frame.size.width / 2.5, CGRectGetMidY(self.frame))
        bird.physicsBody.velocity = CGVectorMake( 0, 0 )
        bird.physicsBody.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score.reset()
        
        // Restart animation
        moving.speed = 1
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if moving.speed > 0  {
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                
                bird.physicsBody.velocity = CGVectorMake(0, 0)
                bird.physicsBody.applyImpulse(CGVectorMake(0, 30))
                
            }
        }else if canRestart {
            self.resetScene()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bird.zRotation = (bird.physicsBody.velocity.dy * ( bird.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 )).clampToValue( between: -1, and: 0.5)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                
                // Bird has contact with score entity
                score.increment()
                
            } else {
                moving.speed = 0
                
                bird.physicsBody.collisionBitMask = worldCategory
                bird.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
                
                flashBackground()
            }
        }
    }
    
    func flashBackground() {
        self.removeActionForKey("flash")
        self.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.runBlock({
            self.backgroundColor = self.errorSkyColor
            }),SKAction.waitForDuration(NSTimeInterval(0.05)), SKAction.runBlock({
                self.backgroundColor = self.normalSkyColor
                }), SKAction.waitForDuration(NSTimeInterval(0.05))]), count:4), SKAction.runBlock({
                    self.canRestart = true
                    })]), withKey: "flash")
        
    }
}
