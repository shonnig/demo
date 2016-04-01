//
//  Card.swift
//  Project11
//
//  Created by Scott Honnigford on 3/31/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Card : SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(imageNamed: String, imageScale: CGFloat) {
        
        // make the border/background
        let cardBackground = SKTexture(imageNamed: "border.jpg")
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: cardBackground.size())
        
        // make the character image and attach to card
        let cardImage = SKSpriteNode(imageNamed: imageNamed)
        cardImage.setScale(imageScale)
        cardImage.zPosition = 15;
        addChild(cardImage)
        
        setScale(0.5)
    }
}