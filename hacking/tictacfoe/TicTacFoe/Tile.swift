//
//  Tile.swift
//  Project11
//
//  Created by Scott Honnigford on 4/1/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKSpriteNode {
    
    static var currentHighlight: Tile?
    
    var row: Int = 0
    var col: Int = 0
    let side = 135
    
    // Card currently occupying the tile
    var occupiedBy: Card?
    
    // sprite for highlight effect
    var glowNode: SKSpriteNode?
    
    
    var attackInterval: CFTimeInterval = 2
    
    var nextAttackTime: CFTimeInterval?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_row: Int, _col: Int) {
        
        row = _row
        col = _col
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: side, height: side))
        
        // make checkerboard pattern to tell tiles apart
        if (row + col) % 2 == 0 {
            colorBlendFactor = 0.7
        }
        else {
            colorBlendFactor = 1.0
        }
        blendMode = SKBlendMode.Replace
        
        // TODO: will we want this?
        //userInteractionEnabled = true

        position = CGPointMake(CGFloat(350 + (col * side)), CGFloat(175 + (row * side)))
        zPosition = ZPosition.Tile.rawValue
        
        // Create the highlight node
        initHighlight()
    }
    
    func initHighlight() {
        // create a copy of our original node create the glow effect
        glowNode = SKSpriteNode(color: UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5), size: CGSize(width: side, height: side))
        glowNode!.setScale(1.1)
        // Make the effect go just under this tile (but above others)
        glowNode!.zPosition = ZPosition.TileHighlight.rawValue - ZPosition.HighlightedTile.rawValue
        glowNode!.hidden = true
        self.addChild(glowNode!)
    }
    
    func addHighlight(card: Card) {
        
        // There can be only one
        if Tile.currentHighlight != self {
            Tile.currentHighlight?.removeHighlight()
            Tile.currentHighlight = self
        }
        
        // Need to raise the highlighted tile above the others so the highlight is below this tile but above others
        zPosition = ZPosition.HighlightedTile.rawValue
        glowNode?.hidden = false
        
        // Green - empty and can be placed, red - occupied and can't
        if isValidPlay(card) {
            glowNode?.color = SKColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            glowNode?.color = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        }
    }
    
    func removeHighlight() {
        Tile.currentHighlight = nil
        zPosition = ZPosition.Tile.rawValue
        glowNode?.hidden = true
    }
    
    func isValidPlay(card: Card) -> Bool {
        // TODO: determine if all tiles are fair to play on or if there are restrictions
        /*
        var validRow = false
        
        if (card.player.isPlayer) {
            if row == 0 || row == 1 {
                validRow = true
            }
        } else {
            if row == 2 || row == 3 {
                validRow = true
            }
        }
        
        return occupiedBy == nil && validRow
        */
        if card.isInHand() {
            // Must be empty tile to play from hand.
            return occupiedBy == nil
        } else {
            // Can be a move to empty or attack
            return occupiedBy == nil || occupiedBy == card || occupiedBy!.player.isPlayer != card.player.isPlayer
        }
    }
    
    func shouldAttackOccupier() -> Bool {
        
        // is there any card to attack?
        if occupiedBy == nil {
            return false
        }
        
        if occupiedBy!.player.isPlayer && row == 3 {
            return true
        }
        
        if !occupiedBy!.player.isPlayer && row == 0 {
            return true
        }
        
        return false
    }
    
    func getAdjacentBasePosition() -> CGPoint? {
        
        var pos = position
        
        if row == 0 {
            pos.y -= 100
            return pos
        }
        
        if row == 3 {
            pos.y += 100
            return pos
        }
        
        return nil
    }
        
    /*
    func update(currentTime: CFTimeInterval) {
        
        // TODO: will need to attack base if next is nil
        if shouldAttackOccupier() {
            if nextAttackTime == nil {
                nextAttackTime = currentTime + attackInterval
            } else {
                if nextAttackTime < currentTime {
                    // attack!
                    occupiedBy?.attackFromBaseToTile(self)
                    nextAttackTime = nil
                }
            }
        } else {
            // reset timer
            nextAttackTime = nil
        }
    }
 */
    
}
