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

    enum Column {
        
        case heroAction
        case hero
        case allyAction
        case ally
        
    }
    
    var character: Character?
    
    static var currentHighlight: Tile?
    
    static let maxRows = 5
    static let maxColumns = 5
    
    var row: Int = 0
    var col: Int = 0
    
    // TODO: make static?
    let side = 100
    
    var owner: Player?

    // Card currently occupying the tile
    var occupiedBy: Card?
    
    // sprite for highlight effect
    var glowNode: SKSpriteNode!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_row: Int, _col: Column, _owner: Player) {
        
        var x: Int
        row = _row
        
        if (_owner.isPlayer) {
            switch _col {
            case .heroAction:
                x = 128
            case .hero:
                x = 256
            default:
                x = 0
            }
        } else {
            switch _col {
            case .heroAction:
                x = 896
            case .hero:
                x = 768
            default:
                x = 0
            }
        }
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: side, height: side))
        position = CGPoint(x: CGFloat(x), y: CGFloat(600 - (row * 150)))
        zPosition = ZPosition.tile.rawValue
        owner = _owner
        isHidden = false
        
        glowNode = SKSpriteNode(texture: SKTexture(imageNamed: "multicolor_circle.png"), size: CGSize(width: Double(side) * 1.7, height: Double(side) * 1.7))
        self.addChild(glowNode)
        glowNode.position = CGPoint(x: 0, y: 0)
        glowNode.zPosition = ZPosition.tileHighlight.rawValue - ZPosition.tile.rawValue
        glowNode.isHidden = true
        
        addHighlight()
    }
    
    func addHighlight() {
        
        glowNode.isHidden = false
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 5)
        glowNode.run(SKAction.repeatForever(rotate), withKey: "rotate")
        
        let grow = SKAction.scale(to: 1.1, duration: 1)
        let shrink = SKAction.scale(to: 0.9, duration: 1)
        let cycle = SKAction.sequence([grow, shrink])
        glowNode.run(SKAction.repeatForever(cycle), withKey: "pulse")
    }
    
    func removeHighlight() {
        glowNode.isHidden = true
        glowNode.removeAction(forKey: "rotate")
        glowNode.removeAction(forKey: "pulse")
    }
    
    /*
    func isValidPlay(_ card: Card) -> Bool {
        let isAttack = (occupiedBy != nil && occupiedBy!.player.isPlayer != card.player.isPlayer)

        if card.isInHand() {
            
            // Is it a unit attack spell?
            if card.hasProp(.unitDamageSpell) {
                return isAttack
            }
            
            // If it's an area attack spell or global spell, it can be played on any tile
            if card.hasProp(.areaDamageSpell) || card.hasProp(.massHeal2) {
                return true
            }
            
            // Must be empty tile and owned by player to play from hand.
            return occupiedBy == nil && owner?.isPlayer == card.player.isPlayer
        } else {
            
            if card.hasProp(.cannotMove) && !isAttack {
                return false
            }
            
            if card.hasProp(.cannotAttack) && isAttack {
                return false
            }
            
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
    */
    
}
