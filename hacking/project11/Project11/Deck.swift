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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init() {
        
        // make the border/background
        let cardBackground = SKTexture(imageNamed: "border.jpg")
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: cardBackground.size())
        
        // allow the Card to intercept touches instead of passing them through the scene
        userInteractionEnabled = true
        
        setScale(0.33)
    }
    
    func drawCard() {
        let card = Card(imageNamed: "Spearman.png", imageScale: 0.25)
        card.position = position
        scene!.addChild(card)
        let gameScene = scene as! GameScene
        gameScene.hand!.addCard(card)
        gameScene.hand!.alignHand()
        
        /*
        let bear = Card(imageNamed: "230px-Miner.png", imageScale: 0.6)
        bear.position = CGPointMake(500, 200)
        addChild(bear)
        hand!.addCard(bear)
        */
    }
    
}