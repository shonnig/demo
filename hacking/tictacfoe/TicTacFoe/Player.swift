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
    
    var goldDiscount = 0 {
        didSet {
            hand!.updateCostLabels()
        }
    }
    
    init(scene: GameScene, _isPlayer: Bool) {
        isPlayer = _isPlayer
        
        var drawDiscardY: CGFloat
        var scoreY: CGFloat
        
        if isPlayer {
            drawDiscardY = 50
            scoreY = 150
            turnButtonY = 225
            bgColor = UIColor.blueColor()
        } else {
            drawDiscardY = 700
            scoreY = 600
            turnButtonY = 550
            bgColor = UIColor.redColor()
        }
        
        let font = "ArialRoundedMTBold"
        
        // Add the gold label
        goldLabel = SKLabelNode(fontNamed: font)
        goldLabel.text = "\(gold)"
        goldLabel.fontSize = 40
        goldLabel.fontColor = UIColor.yellowColor()
        goldLabel.zPosition = ZPosition.HudUI.rawValue
        goldLabel.position = CGPointMake(75,scoreY)
        scene.addChild(goldLabel)
        
        // Add the score label
        scoreLabel = SKLabelNode(fontNamed: font)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.zPosition = ZPosition.HudUI.rawValue
        scoreLabel.position = CGPointMake(150,scoreY)
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