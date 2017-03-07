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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHealthLabel() {
        statsLabel.outlinedText = "\(health)/\(maxHealth)"
        
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
        
        maxHealth = 1
        health = 1
        
        let font = "ArialRoundedMTBold"
        
        // Add the health label
        statsLabel = MKOutlinedLabelNode(fontNamed: font, fontSize: 20)
        statsLabel.fontColor = UIColor.white
        statsLabel.borderColor = UIColor.black
        statsLabel.borderWidth = 1
        statsLabel.outlinedText = "\(health)/\(maxHealth)"
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
    }

    
}
