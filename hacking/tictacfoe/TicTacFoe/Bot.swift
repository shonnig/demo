//
//  Bot.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 10/27/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit


class Bot : SKSpriteNode {

    
    init() {
    
        let _texture = SKTexture(imageNamed: "Battletank.png")
        let _size = CGSize(width: 48, height: 64)
        super.init(texture: _texture, color: UIColor.white, size: _size)
        physicsBody = SKPhysicsBody(texture: _texture, size: _size)
        physicsBody?.mass = 10.0
        physicsBody?.linearDamping = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
