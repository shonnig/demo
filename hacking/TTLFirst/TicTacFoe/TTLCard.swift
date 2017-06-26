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
    
    var mOriginalPosition: CGPoint?
    
    var mZoomed = false
    
    func moveTo(_ x: Int, _ y: Int) {
        // TODO: stop animation in progress? Only for movement?
        
        let moveTo = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.6)
        moveTo.timingMode = SKActionTimingMode.easeInEaseOut;
        run(moveTo, withKey: "move")
    }
    
    // Zoomed in view of the card when touching it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(2) // TODO
        zPosition += 5000 // TODO
        mOriginalPosition = position
        position = CGPoint(x: position.x, y: 400) // TODO
        mZoomed = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mZoomed {
            setScale(1) // TODO
            zPosition -= 5000 // TODO
            if let origPos = mOriginalPosition {
                position = origPos
            }
            mZoomed = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mZoomed {
            setScale(1) // TODO
            zPosition -= 5000 // TODO
            if let origPos = mOriginalPosition {
                position = origPos
            }
            mZoomed = false
        }
    }
}
