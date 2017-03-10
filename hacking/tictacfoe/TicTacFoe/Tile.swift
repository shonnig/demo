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
    
    var m_card: Card?
    
    // Character that is in this row (may be on this tile itself)
    var character: Character?
    
    var row: Int = 0
    var col: Int = 0
    
    var owner: Player?
    
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
                x = 100
            case .hero:
                x = 280
            default:
                x = 0
            }
        } else {
            switch _col {
            case .heroAction:
                x = 924
            case .hero:
                x = 744
            default:
                x = 0
            }
        }
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: GameScene.side, height: GameScene.side))
        position = CGPoint(x: CGFloat(x), y: CGFloat(650 - (row * 180)))
        zPosition = ZPosition.tile.rawValue
        owner = _owner
        isHidden = false
        
        glowNode = SKSpriteNode(texture: SKTexture(imageNamed: "multicolor_circle.png"), size: CGSize(width: Double(GameScene.side) * 1.7, height: Double(GameScene.side) * 1.7))
        self.addChild(glowNode)
        glowNode.position = CGPoint(x: 0, y: 0)
        glowNode.zPosition = ZPosition.tileHighlight.rawValue - ZPosition.tile.rawValue
        glowNode.isHidden = true
    }
    
    func enableForRally() {
        addHighlight()
        m_card?.enabledForRally = true
    }
    
    func disableForRally() {
        removeHighlight()
        m_card?.enabledForRally = false
    }
    
    func enableForTarget() {
        addHighlight()
        character?.enabledForTarget = true
    }
    
    func disableForTarget() {
        removeHighlight()
        character?.enabledForTarget = false
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
    
    // TODO: Need different attack types (not just melee attack)
    //
    func attackTile(_ toTile: Tile) {
        
        //let defendingPlayer = toTile.owner,
        if let attackingPlayer = owner, let attackingUnit = character, let defendingUnit = toTile.character, let attackingCard = owner?.mHeroActionTiles[self.row].m_card {
            
            // damage image
            let dmgImage = SKSpriteNode(imageNamed: "Explosion.png")
            dmgImage.setScale(0.25)
            dmgImage.position = toTile.position
            dmgImage.zPosition = ZPosition.damageEffect.rawValue
            dmgImage.isHidden = true
            scene!.addChild(dmgImage)
            
            let wait1 = SKAction.wait(forDuration: 0.8)
            let showDmg = SKAction.unhide()
            let doDmg = SKAction.run( { defendingUnit.applyDamage(attackingPlayer.currentAttackDamage) } )
            let wait2 = SKAction.wait(forDuration: 0.3)
            let fadeDmg = SKAction.fadeOut(withDuration: 0.3)
            let removeDmg = SKAction.removeFromParent()
            let dmgCycle = SKAction.sequence([wait1, showDmg, doDmg, wait2, fadeDmg, removeDmg])
            dmgImage.run(dmgCycle, withKey: "damage")
            
            // animate attack
            // TODO: make separate function? And probably can do math directly on points?
            // find partial position to opponent
            let oppPos = defendingUnit.position
            let xDiff = (oppPos.x - position.x) * 0.90
            let yDiff = (oppPos.y - position.y) * 0.90
            let attPos = CGPoint(x: position.x + xDiff, y: position.y + yDiff)
            
            let firstWait = SKAction.wait(forDuration: 0.5)
            let attackTo = SKAction.move(to: attPos, duration: 0.3)
            let secondWait = SKAction.wait(forDuration: 0.3)
            let attackBack = SKAction.move(to: self.position, duration: 0.3)
            let complete = SKAction.run( { attackingCard.resolveComplete() } )
            let cycle = SKAction.sequence([firstWait, attackTo, secondWait, attackBack, complete])
            attackingUnit.run(cycle, withKey: "attack")
        }
    }
}
