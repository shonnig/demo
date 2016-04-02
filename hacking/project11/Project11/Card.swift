//
//  Card.swift
//  Project11
//
//  Created by Scott Honnigford on 3/31/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Card : SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(imageNamed: String, imageScale: CGFloat) {
        
        // make the border/background
        let cardBackground = SKTexture(imageNamed: "border.jpg")
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: cardBackground.size())
 
        // allow the Card to intercept touches instead of passing them through the scene
        userInteractionEnabled = true
        
        // make the character image and attach to card
        let cardImage = SKSpriteNode(imageNamed: imageNamed)
        cardImage.setScale(imageScale)
        cardImage.zPosition = 1;
        addChild(cardImage)
        
        setScale(0.33)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            // note: removed references to touchedNode
            // 'self' in most cases is not required in Swift
            zPosition = 30
            let liftUp = SKAction.scaleTo(0.5, duration: 0.2)
            runAction(liftUp, withKey: "pickup")
            
            
            let rotR = SKAction.rotateByAngle(0.07, duration: 0.25)
            let rotL = SKAction.rotateByAngle(-0.07, duration: 0.25)
            let cycle = SKAction.sequence([rotR, rotL, rotL, rotR])
            let wiggle = SKAction.repeatActionForever(cycle)
            runAction(wiggle, withKey: "wiggle")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(scene!) // make sure this is scene, not self
            let touchedNode = nodeAtPoint(location)
            touchedNode.position = location
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            zPosition = 0
            let dropDown = SKAction.scaleTo(0.33, duration: 0.2)
            runAction(dropDown, withKey: "drop")
            removeActionForKey("wiggle")
            runAction(SKAction.rotateToAngle(0, duration: 0.2), withKey:"rotate")
        }
    }

}