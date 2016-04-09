//
//  Discard.swift
//  Project11
//
//  Created by Scott Honnigford on 4/9/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//
import Foundation
import SpriteKit

class Discard : SKSpriteNode {
    
    var isPlayer: Bool
    
    var cards = [Card]()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_isPlayer: Bool) {
        
        isPlayer = _isPlayer
        
        // make the border/background
        var cardBackground: SKTexture
        // TODO: use different colors or something eventually for different teams
        if isPlayer {
            cardBackground = SKTexture(imageNamed: "border.jpg")
        } else {
            cardBackground = SKTexture(imageNamed: "enemy_card.jpg")
        }
        
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: CGSize(width: 200, height: 300))
        
        // allow the Card to intercept touches instead of passing them through the scene
        //userInteractionEnabled = true
        
        setScale(0.33)
    }
}
