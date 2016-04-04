//
//  Card.swift
//  Project11
//
//  Created by Scott Honnigford on 3/31/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

enum CardLocation {
    case Hand
    // row and col
    case Tile(Int, Int)
    case Deck
    case Discard
    case Choice
}

class Card : SKSpriteNode {
    
    var location: CardLocation?
    
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

    func isInHand() -> Bool {
        var ret:Bool
        switch location! {
        case .Hand: ret = true
        default: ret = false
        }
        return ret
    }
    
    func moveFromHandToTile(toTile: Tile) {
        
        // take out of hand
        let gameScene = scene as! GameScene
        gameScene.hand!.removeCard(self)
        
        // set on board
        // TODO: location must be changed after removing from Hand - fix this requirement?
        location = .Tile(toTile.row, toTile.col)
        // TODO: add check that this tile isn't already occupied?
        toTile.occupiedBy = self
        
        // animate to this
        let snapToPosition = toTile.position
        let snapTo = SKAction.moveTo(snapToPosition, duration: 0.2)
        runAction(snapTo, withKey: "snap")
        
        // align hand
        gameScene.hand!.alignHand()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Can only move cards from hand
        if !isInHand() {
            return
        }
        
        // TODO: do we really need to loop through all these?
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
        
        // Can only move cards from hand
        if !isInHand() {
            return
        }
        
        for touch in touches {
            let location = touch.locationInNode(scene!) // make sure this is scene, not self
            let touchedNode = nodeAtPoint(location)
            touchedNode.position = location
            
            // TODO: remove highlight if we moved off of tile board?
            let nodes = scene?.nodesAtPoint(location)
            for node in nodes! {
                if node is Tile {
                    let tile = node as! Tile
                    tile.addHighlight()
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Can only move cards from hand
        if !isInHand() {
            return
        }
        
        // TODO: do we need loop?
        // TODO: move this also to move card logic?
        for _ in touches {
            zPosition = 0
            let dropDown = SKAction.scaleTo(0.33, duration: 0.2)
            runAction(dropDown, withKey: "drop")
            removeActionForKey("wiggle")
            runAction(SKAction.rotateToAngle(0, duration: 0.2), withKey:"rotate")
        }
        
        // Move card to selected tile if it is a valid play
        if (Tile.currentHighlight != nil && Tile.currentHighlight!.occupiedBy == nil) {
            moveFromHandToTile(Tile.currentHighlight!)
        }
        
        if Tile.currentHighlight != nil {
            Tile.currentHighlight?.removeHighlight()
        }
            
        // Should be able to realign hand and have card return?
        let gameScene = scene as! GameScene
        gameScene.hand!.alignHand()
    }
}