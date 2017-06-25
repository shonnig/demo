//
//  TTLCard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLCard: SKSpriteNode {
    
    func moveTo(_ x: Int, _ y: Int) {
        // TODO: stop animation in progress? Only for movement?
        
        let moveTo = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.6)
        run(moveTo, withKey: "move")
    }
}
