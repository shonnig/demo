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
    
    var tiles = [Tile]()
    
    var deck: Deck?
    
    var discard: Discard?
    
    var hand: Hand?
    
    var gold: Int = 1 {
        didSet {
            goldLabel.text = "\(gold) (+\(goldPerTurn)) [\(investments)/\(goldPerTurn)]"
            
            // this will change cards highlighting based on if they are playable now
            //hand!.setFaceUp(true)
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
            //updateScoreLabel()
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var otherPlayer: Player?
    
    /*
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
    */
    
    init(scene: GameScene, _isPlayer: Bool) {
        
        isPlayer = _isPlayer
        
        for row in 0...3 {
            
            let heroActionTile = Tile(_row: row, _col: .heroAction, _owner: self)
            tiles.append(heroActionTile)
            scene.addChild(heroActionTile)
            
            let heroTile = Tile(_row: row, _col: .hero, _owner: self)
            tiles.append(heroTile)
            scene.addChild(heroTile)
            
            let hero = Hero(type: HeroType.random())
            hero.position = heroTile.position
            scene.addChild(hero)
            heroTile.character = hero
        }
        
        /*
        var drawDiscardY: CGFloat
        var scoreY: CGFloat
        
        if isPlayer {
            drawDiscardY = 50
            scoreY = 150
            turnButtonY = 225
            bgColor = UIColor.blue
        } else {
            drawDiscardY = 700
            scoreY = 600
            turnButtonY = 550
            bgColor = UIColor.red
        }
        
        let font = "ArialRoundedMTBold"
        
        
        // Add the gold label
        goldLabel = SKLabelNode(fontNamed: font)
        goldLabel.text = "\(gold)"
        goldLabel.fontSize = 40
        goldLabel.fontColor = UIColor.yellow
        goldLabel.zPosition = ZPosition.hudUI.rawValue
        goldLabel.position = CGPoint(x: 150,y: scoreY)
        scene.addChild(goldLabel)
        
        // Add the score label
        scoreLabel = SKLabelNode(fontNamed: font)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = ZPosition.hudUI.rawValue
        scoreLabel.position = CGPoint(x: 175,y: scoreY)
        scene.addChild(scoreLabel)
        // TODO: not going to use a score now? Just hide for the time being.
        scoreLabel.isHidden = true
 
        // Player's hand
        hand = Hand(_player: self)
        
        // Player's deck
        deck = Deck(_player: self)
        deck!.position = CGPoint(x: 900,y: drawDiscardY)
        scene.addChild(deck!)
        
        // Player's discard
        discard = Discard(_player: self)
        discard!.position = CGPoint(x: 150,y: drawDiscardY)
        scene.addChild(discard!)
        */
    }

    /*
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
    */
}
