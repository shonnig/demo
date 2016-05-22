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
    
    static let maxRows = 4
    static let maxColumns = 5
    
    var row: Int = 0
    var col: Int = 0
    
    // TODO: make static?
    let side = 135
    
    // Player who "owns" the tile
    var owner: Player? {
        didSet {
            if owner == nil {
                color = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            } else {
                color = owner!.bgColor
            }
            
            // Need to update score labels as pending score probably changed
            let gameScene = scene as! GameScene
            gameScene.player!.updateScoreLabel()
            gameScene.opponent!.updateScoreLabel()
        }
    }
    
    // Card currently occupying the tile
    var occupiedBy: Card?
    
    // sprite for highlight effect
    var glowNode: SKSpriteNode?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_row: Int, _col: Int, _owner: Player?) {
        
        row = _row
        col = _col
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: side, height: side))
        
        // make checkerboard pattern to tell tiles apart
        if (row + col) % 2 == 0 {
            colorBlendFactor = 0.2
        }
        else {
            colorBlendFactor = 0.4
        }
        blendMode = SKBlendMode.Replace

        position = CGPointMake(CGFloat(350 + (col * side)), CGFloat(175 + (row * side)))
        zPosition = ZPosition.Tile.rawValue
        
        owner = _owner
        if owner != nil {
            color = owner!.bgColor
        }
        
        // Create the highlight node
        initHighlight()
    }
    
    func initHighlight() {
        // create a copy of our original node to create the glow effect
        glowNode = SKSpriteNode(color: UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5), size: CGSize(width: side, height: side))
        glowNode!.setScale(1.1)
        // Make the effect go just under this tile (but above others)
        glowNode!.zPosition = ZPosition.TileHighlight.rawValue - ZPosition.HighlightedTile.rawValue
        glowNode!.hidden = true
        self.addChild(glowNode!)
    }
    
    func addHighlight(card: Card) {
        
        // There can be only one - TODO: we may need to add a different type of highlight for available selections
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
        let isAttack = (occupiedBy != nil && occupiedBy!.player.isPlayer != card.player.isPlayer)

        if card.isInHand() {
            
            // Is it a unit attack spell?
            if card.hasProp(.unitDamageSpell) {
                return isAttack
            }
            
            // If it's an area attack spell, it can be played on any tile
            if card.hasProp(.areaDamageSpell) {
                return true
            }
            
            // Must be empty tile and owned by player to play from hand.
            return occupiedBy == nil && owner?.isPlayer == card.player.isPlayer
        } else {
            // Can be a move to empty or attack, and by default only one space
            // TODO: don't allow diagonal moves/attacks?
            let validTarget = (occupiedBy == nil || occupiedBy == card || isAttack)
            let current = card.currentTile()
            
            let rowOffset = abs(row - current!.row)
            let colOffset = abs(col - current!.col)
            var maxRange = 1
            
            // If attacking, range units may have more reach
            if isAttack {
                maxRange = max(maxRange, card.range)
            }
            
            var validDistance = ((rowOffset <= maxRange) && (colOffset <= maxRange))
            
            // Trailblazing 2 allows you to move spaces orthogonally
            if card.hasProp(.trailblazer2) {
                if (rowOffset == 0 && colOffset <= 2) || (rowOffset <= 2 && colOffset == 0) {
                    validDistance = true
                }
            }
        
            return validTarget && validDistance
        }
    }
    
}
