//
//  PlayerNode.swift
//  Jump!
//
//  Created by Kyle Minshall on 12/11/14.
//  Copyright (c) 2014 tmg. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class PlayerNode: SKNode {
    
    let player = SKSpriteNode(imageNamed: "Circle.png")

    override init() {
        super.init()
        name = "Player"
        initNodeGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    private func initNodeGraph() {
        
        player.name = "Player"
        player.zRotation = CGFloat(M_PI)
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Circle.png"), size: player.size)
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.dynamic = false
        player.physicsBody?.linearDamping = 0.0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = true
        self.addChild(player)
    }
    
    internal func jump(location: CGPoint, right: Bool) {
        player.physicsBody!.velocity = CGVectorMake(0,0)
        right ?
            player.physicsBody!.applyImpulse(CGVectorMake(CGFloat(-3), CGFloat(15))) :
            player.physicsBody!.applyImpulse(CGVectorMake(CGFloat(3), CGFloat(15)))
    }
    
    internal func activate() {
        player.physicsBody?.dynamic = true
    }
}
