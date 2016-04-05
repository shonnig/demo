//
//  Deck.swift
//  Project11
//
//  Created by Scott Honnigford on 4/4/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Deck : SKSpriteNode {
    
    let drawInterval:CFTimeInterval = 10
    
    var nextDrawTime:CFTimeInterval
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init() {
        
        nextDrawTime = 0
        
        // make the border/background
        let cardBackground = SKTexture(imageNamed: "border.jpg")
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: cardBackground.size())
        
        // allow the Card to intercept touches instead of passing them through the scene
        userInteractionEnabled = true
        
        setScale(0.33)
    }
    
    // TODO: obviously need to populate cards in deck instead of magically creating them
    func drawCard() {
        let gameScene = scene as! GameScene
        let hand = gameScene.hand!

        // Can never go beyond max hand size
        if hand.isFull() {
            return
        }
        
        let card = Card(imageNamed: "Spearman.png", imageScale: 0.25)
        card.position = position
        scene!.addChild(card)
        hand.addCard(card)
        hand.alignHand()
        
        /*
        let bear = Card(imageNamed: "230px-Miner.png", imageScale: 0.6)
        bear.position = CGPointMake(500, 200)
        addChild(bear)
        hand!.addCard(bear)
        */
    }
    
    // TODO: should have a UI indicator for how long until next draw - should timer reset or hold if hand is full?
    // periodically draw a card
    func update(currentTime: CFTimeInterval) {
        
        if nextDrawTime < currentTime {
            drawCard()
            nextDrawTime = currentTime + drawInterval
        }
    }
    
}