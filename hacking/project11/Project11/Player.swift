//
//  Player.swift
//  Project11
//
//  Created by Scott Honnigford on 4/12/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit


class Player {

    let isPlayer: Bool
    
    var deck: Deck?
    
    var discard: Discard?
    
    var hand: Hand?
    
    var life: Int = 20 {
        didSet {
            lifeLabel.text = "\(life)"
        }
    }
    
    var lifeLabel: SKLabelNode!
    
    var lifeLabelShadow: SKLabelNode!
    
    var otherPlayer: Player?
    
    init(scene: GameScene, _isPlayer: Bool) {
        isPlayer = _isPlayer
        
        var drawDiscardY: CGFloat
        
        if isPlayer {
            drawDiscardY = 50
        } else {
            drawDiscardY = 700
        }
        
        life = 20
        // Add the life label
        lifeLabel = SKLabelNode(fontNamed: "Arial")
        lifeLabel.text = "\(life)"
        lifeLabel.fontSize = 40
        lifeLabel.fontColor = UIColor.whiteColor()
        lifeLabel.zPosition = 2000
        lifeLabel.position = CGPointMake(50,drawDiscardY)
        
        lifeLabelShadow = SKLabelNode(fontNamed: "Arial")
        lifeLabelShadow.text = "\(life)"
        lifeLabelShadow.fontSize = 40
        lifeLabelShadow.fontColor = UIColor.blackColor()
        lifeLabelShadow.zPosition = 1999
        lifeLabelShadow.position = CGPointMake(53,drawDiscardY - 3)
        
        scene.addChild(lifeLabel)
        scene.addChild(lifeLabelShadow)
        
        // Player's hand
        hand = Hand(_player: self)
        
        // Player's deck
        deck = Deck(_player: self)
        deck!.position = CGPointMake(900,drawDiscardY)
        scene.addChild(deck!)
        
        // Player's discard
        discard = Discard(_player: self)
        discard!.position = CGPointMake(150,drawDiscardY)
        scene.addChild(discard!)
    }

}