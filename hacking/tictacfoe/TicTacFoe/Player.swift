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
    
    var gold: Int = 0 {
        didSet {
            goldLabel.text = "\(gold)"
        }
    }
    
    var goldLabel: SKLabelNode!
    
    //var goldLabelShadow: SKLabelNode!
    
    var otherPlayer: Player?
    
    var turnButtonY: CGFloat
    
    init(scene: GameScene, _isPlayer: Bool) {
        isPlayer = _isPlayer
        
        var drawDiscardY: CGFloat
        
        if isPlayer {
            drawDiscardY = 50
            turnButtonY = 200
        } else {
            drawDiscardY = 700
            turnButtonY = 600
        }
        
        // Add the gold label
        goldLabel = SKLabelNode(fontNamed: "Arial")
        goldLabel.text = "\(gold)"
        goldLabel.fontSize = 40
        goldLabel.fontColor = UIColor.whiteColor()
        goldLabel.zPosition = 2000
        goldLabel.position = CGPointMake(50,drawDiscardY)
        scene.addChild(goldLabel)

        
        /*
        goldLabelShadow = SKLabelNode(fontNamed: "Arial")
        goldLabelShadow.text = "\(gold)"
        goldLabelShadow.fontSize = 40
        goldLabelShadow.fontColor = UIColor.blackColor()
        goldLabelShadow.zPosition = 1999
        goldLabelShadow.position = CGPointMake(53,drawDiscardY - 3)
        scene.addChild(goldLabelShadow)
        */
        
        
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