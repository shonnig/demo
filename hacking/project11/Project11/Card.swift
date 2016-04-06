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
    
    // TODO: temp, will eventually vary by card type
    let moveInterval: CFTimeInterval = 2
    
    var nextMoveTime: CFTimeInterval?
    
    var location: CardLocation?
    
    var isPickedUp = false
    
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
    
    func update(currentTime: CFTimeInterval) {
        
        // TODO: after adding teams, don't assume direction
        // See if next tile up is valid and free
        var nextTileIndex: Int?
        var currentTileIndex: Int?
        switch location! {
        case .Tile(let row, let col):
            nextTileIndex = ((row + 1) * 5) + col
            currentTileIndex = (row * 5) + col
        default:
            break
        }
            
        // TODO: really need constants for row/col ranges
        if nextTileIndex != nil && nextTileIndex >= 0 && nextTileIndex < 19 {
            
            // Timer expired and it's still free - we can move!
            let gameScene = scene as! GameScene
            let nextTile = gameScene.tiles[nextTileIndex!]
            let currentTile = gameScene.tiles[currentTileIndex!]
                    
            if nextTile.occupiedBy == nil {
                
                if nextMoveTime == nil {
                    // Next space is free, we can start the timer
                    nextMoveTime = currentTime + moveInterval
                } else {
                    if nextMoveTime < currentTime {
                        // Timer expired and space is still free, we can move!
                        moveFromTileToTile(currentTile, toTile: nextTile)
                        nextMoveTime = nil
                    }
                }
            } else {
                // Space is occupied - reset timer
                nextMoveTime = nil
            }
        }
    }

    func moveFromTileToTile(fromTile: Tile, toTile: Tile) {
     
        fromTile.occupiedBy = nil
        
        location = .Tile(toTile.row, toTile.col)
        // TODO: add check that this tile isn't already occupied?
        toTile.occupiedBy = self
        
        // animate to this
        let snapToPosition = toTile.position
        let snapTo = SKAction.moveTo(snapToPosition, duration: 0.2)
        runAction(snapTo, withKey: "snap")

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
        //for _ in touches {
            // note: removed references to touchedNode
            // 'self' in most cases is not required in Swift
            zPosition = 30
            let liftUp = SKAction.scaleTo(0.5, duration: 0.2)
            runAction(liftUp, withKey: "pickup")
            
            startWiggle()
            isPickedUp = true
        //}
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
            startWiggle()
            
            // Remove highlight, then add it back if it's still over a tile
            if Tile.currentHighlight != nil {
                Tile.currentHighlight?.removeHighlight()
            }
            
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
        //for _ in touches {
            let dropDown = SKAction.scaleTo(0.33, duration: 0.2)
            runAction(dropDown, withKey: "drop", optionalCompletion: lowerPosition)
            stopWiggle()
            isPickedUp = false
        //}
        
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
    
    func startWiggle() {
        // TODO - is it ok to check for any actions?
        if hasActions() == false {
            let startAngle = CGFloat(RandomFloat(min: 0.05, max: 0.1))
            let secondAngle = CGFloat(startAngle * -1.0)
            let time = NSTimeInterval(startAngle * 2.0)
            
            
            let rotBack = SKAction.rotateToAngle(0, duration: 0.15)
            let rotR = SKAction.rotateByAngle(startAngle, duration: time)
            let rotL = SKAction.rotateByAngle(secondAngle, duration: time)
            var cycle:SKAction
            
            // 50/50 left or right first
            if (RandomInt(min: 0,max: 1) == 0) {
                cycle = SKAction.sequence([rotBack, rotR, rotL])
            } else {
                cycle = SKAction.sequence([rotBack, rotL, rotR])
            }

            runAction(cycle, withKey: "wiggle")
        }
    }
    
    func stopWiggle() {
        removeActionForKey("wiggle")
        
        // return card back to normal angle
        runAction(SKAction.rotateToAngle(0, duration: 0.2), withKey:"rotate")
    }
    
    func lowerPosition() {
        zPosition = 0
    }

}