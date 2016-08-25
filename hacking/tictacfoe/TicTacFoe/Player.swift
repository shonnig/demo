//
//  Player.swift
//  Project11
//
//  Created by Scott Honnigford on 4/12/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

// hello world!!!!
// another test

import Foundation
import SpriteKit


class Player {

    let isPlayer: Bool
    
    var deck: Deck?
    
    var discard: Discard?
    
    var hand: Hand?
    
    var gold: Int = 1 {
        didSet {
            goldLabel.text = "\(gold) (+\(goldPerTurn)) [\(investments)/\(goldPerTurn)]"
            
            // this will change cards highlighting based on if they are playable now
            hand!.setFaceUp(true)
        }
    }
    
    var goldLabel: SKLabelNode!

    var goldPerTurn: Int = 0 {
        didSet {
            goldLabel.text = "\(gold) (+\(goldPerTurn)) [\(investments)/\(goldPerTurn)]"
        }
    }
    
    var investments: Int = 0 {
        didSet {
            goldLabel.text = "\(gold) (+\(goldPerTurn)) [\(investments)/\(goldPerTurn)]"
        }
    }
    
    var score: Int = 0 {
        didSet {
            updateScoreLabel()
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var otherPlayer: Player?
    
    var turnButtonY: CGFloat
    
    var bgColor: UIColor
    
    var goldDiscount = 0 {
        didSet {
            hand!.updateCostLabels()
            discard!.updateCostLabels()
            
            let gameScene = deck!.scene as! GameScene
            
            // Update all cards on board too
            for tile in gameScene.tiles {
                if tile.occupiedBy != nil && tile.occupiedBy!.player.isPlayer == isPlayer {
                    tile.occupiedBy?.updateCostLabel()
                }
            }
        }
    }
    
    func updateScoreLabel() {
        let pendingScore = getScorePoints()
        
        if pendingScore > 0 {
            scoreLabel.text = "\(score) (+\(pendingScore))"
        } else {
            scoreLabel.text = "\(score)"
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
        goldLabel.position = CGPointMake(150,scoreY)
        scene.addChild(goldLabel)
        
        // Add the score label
        scoreLabel = SKLabelNode(fontNamed: font)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.zPosition = ZPosition.HudUI.rawValue
        scoreLabel.position = CGPointMake(175,scoreY)
        scene.addChild(scoreLabel)
        // TODO: not going to use a score now? Just hide for the time being.
        scoreLabel.hidden = true
        
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

    func getScorePoints() -> Int {
        
        let gameScene = deck!.scene as! GameScene
        var tilesOwned = 0
        
        for tile in gameScene.tiles {
            
            // find tiles owned for scoring
            if tile.owner?.isPlayer == isPlayer {
                tilesOwned += 1
            }
        }
        
        // Score points for every tile owned above ten at the end of the turn
        let scoreThreshold = 10
        if tilesOwned > scoreThreshold {
            return (tilesOwned - scoreThreshold)
        } else {
            return 0
        }
    }
}