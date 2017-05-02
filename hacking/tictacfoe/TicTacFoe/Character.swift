//
//  Character.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 2/12/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Character : SKSpriteNode {

    var maxHealth: Int {
        didSet {
            updateHealthLabel()
        }
    }
    
    var health: Int {
        didSet {
            updateHealthLabel()
        }
    }
    
    var m_tile: Tile?
    
    var deck: Deck?
    
    var discard: Discard?
    
    var hand: Hand?
    
    var statsLabel: MKOutlinedLabelNode
    
    var enabledForTarget = false
    
    var facingRight = true
    
    var mImageName: String
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHealthLabel() {
        statsLabel.outlinedText = "\(health)" //"\(health)/\(maxHealth)"
        
        if health <= 0 {
            //die()
        }
        
        // White if fully healed, red if damaged
        if health < maxHealth {
            statsLabel.fontColor = UIColor.red
        } else {
            statsLabel.fontColor = UIColor.white
        }
    }
    
    init(imgName: String) {
        
        // Will get overriden in Hero code
        maxHealth = 1
        health = 1
        
        mImageName = imgName
        
        let font = "ChunkFive-Roman"
        
        // Add the health label
        statsLabel = MKOutlinedLabelNode(fontNamed: font, fontSize: 32)
        statsLabel.fontColor = UIColor.white
        statsLabel.borderColor = UIColor.black
        statsLabel.borderWidth = 2
        statsLabel.outlinedText = "\(health)" //"\(health)/\(maxHealth)"
        statsLabel.zPosition = ZPosition.cardLabel.rawValue - ZPosition.cardInHand.rawValue
        statsLabel.position = CGPoint(x: 40,y: -60)
        
        // Set size keeping original aspect ratio. Using height as maximum check for now.
        // TODO: use const/config for height
        let _texture = SKTexture(imageNamed: imgName)
        let reScale = GameScene.side / _texture.size().height
        super.init(texture: _texture, color: UIColor.white, size: CGSize(width: reScale * _texture.size().width, height: reScale * _texture.size().height))

        addChild(statsLabel)
    }
    
    func placeOnTile(tile: Tile) {
        isHidden = false
        position = tile.position
        zPosition = ZPosition.inPlay.rawValue
        m_tile = tile
        tile.character = self
        
        // Do we need to flip the image of the character?
        if let player = m_tile?.owner {
            if player.isPlayer != facingRight {
                let flippedImage = SKTexture.flipImage(name: mImageName, flipHoriz: true, flipVert: false)
                let flipIt = SKAction.setTexture(flippedImage)
                run(flipIt)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Did player select this card while it's in their hand?
        // TODO: having to assume this is an attack right now.
        if enabledForTarget {
            if let tile = m_tile, let defendingPlayer = tile.owner, let attackingPlayer = defendingPlayer.otherPlayer, let attacker = attackingPlayer.currentAttacker {
                attacker.attackTile(tile)
                
                // Disable other targets
                for target in defendingPlayer.mHeroTiles {
                    target.disableForTarget()
                }
            }
        }
    }
    
    func death() {
        if let player = m_tile?.owner, let row = m_tile?.row {
            removeFromParent()
            let heroTile = player.mHeroTiles[row]
            heroTile.character = nil
            
            let cardTile = player.mHeroActionTiles[row]
            cardTile.m_card?.removeFromParent()
            cardTile.m_card = nil
            m_tile = nil
            
            // Check if all heroes are dead
            var allDead = true
            for tile in player.mHeroTiles {
                if tile.character != nil {
                    allDead = false
                    break
                }
            }
            
            if allDead {
                player.lost = true
            }
            
        }
    }
    
    func applyDamage(_ damage: Int) {
        health -= damage
        
        // Death!
        if health <= 0 {
            health = 0
            
            // Fade to death
            let fade = SKAction.fadeOut(withDuration: 0.4)
            //let remove = SKAction.removeFromParent() // I've verified this deletes the node
            let kill = SKAction.run( { self.death() } )
            let rally = SKAction.sequence([fade, kill])
            run(rally, withKey: "death")
        }
    }
    
    func applyHeal(_ amount: Int) {
        health += amount
        if health > maxHealth {
            health = maxHealth
        }
    }
}
