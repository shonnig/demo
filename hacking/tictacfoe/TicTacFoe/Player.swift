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
            
            // this will change cards highlighting based on if they are playable now
            hand!.setFaceUp(true)
        }
    }
    
    var goldLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var otherPlayer: Player?
    
    var turnButtonY: CGFloat
    
    var bgColor: UIColor
    
    init(scene: GameScene, _isPlayer: Bool) {
        isPlayer = _isPlayer
        
        var drawDiscardY: CGFloat
        
        if isPlayer {
            drawDiscardY = 50
            turnButtonY = 200
            bgColor = UIColor.blueColor()
        } else {
            drawDiscardY = 700
            turnButtonY = 600
            bgColor = UIColor.greenColor()
        }
        
        // Add the gold label
        goldLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        goldLabel.text = "\(gold)"
        goldLabel.fontSize = 40
        goldLabel.fontColor = UIColor.yellowColor()
        goldLabel.zPosition = ZPosition.HudUI.rawValue
        goldLabel.position = CGPointMake(50,drawDiscardY)
        scene.addChild(goldLabel)
        
        // Add the score label
        scoreLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.zPosition = ZPosition.HudUI.rawValue
        scoreLabel.position = CGPointMake(125,drawDiscardY)
        scene.addChild(scoreLabel)
        
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