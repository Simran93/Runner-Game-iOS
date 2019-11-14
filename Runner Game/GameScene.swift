//
//  GameScene.swift
//  Runner Game
//
//  Created by Simranjeet  Singh on 2019-11-13.
//  Copyright © 2019 Simranjeet  Singh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    var cat: CatNode!
     var platforms = [SKSpriteNode]()
    var lastTime: TimeInterval?
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
        let snowEmitter = SKEmitterNode(fileNamed: "MyParticle")
        snowEmitter?.position = CGPoint(x: 0, y: 400)
        self.addChild(snowEmitter!)

        
           let backgroundTexture = SKTexture(image: UIImage(named: "background")!)
           let backgroundNode = SKSpriteNode(texture: backgroundTexture)
           backgroundNode.size = CGSize(width: 1334, height: 750)
           self.addChild(backgroundNode)
       

        let catTexture = SKTexture(image: UIImage(named: "cat_run_1")!)
        let catSize = CGSize(width: 140, height: 140)
        self.cat = CatNode(texture: catTexture, color: UIColor.white, size: catSize)
        self.cat.position = CGPoint(x: -520, y: -200)
        self.addChild(self.cat)
        self.cat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 140))
        
       self.cat.physicsBody?.allowsRotation = false
       self.cat.startRunAnimation()

        self.cat.physicsBody?.collisionBitMask = 1
        

        
        for i in 0 ..< 10 {
            let platformX = (-440 + (i * 400))
            
            let platform = SKSpriteNode(texture: SKTexture(image: UIImage(named: "platform")!))
            platform.size = CGSize(width: 256, height: 64)
            platform.position = CGPoint(x: platformX, y: -232)
            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
            platform.physicsBody?.isDynamic = false
            self.platforms.append(platform)
            self.addChild(platform)
            platform.physicsBody?.contactTestBitMask = 1
        }
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let cat = (contact.bodyA.node as? CatNode) ?? (contact.bodyB.node as? CatNode)

        if cat?.isJumping ?? false {
            cat?.startRunAnimation()
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       cat.jump()
          self.cat.startJumpAnimation()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if lastTime == nil {
            lastTime = currentTime
            return
        }
        for platform in self.platforms{
            platform.position.x = platform.position.x - CGFloat(340 * (currentTime - lastTime!))
        }
        lastTime = currentTime
        
        
    }
}
