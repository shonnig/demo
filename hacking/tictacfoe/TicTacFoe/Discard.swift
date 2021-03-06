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
    
    var cards = [Card]()
    
    var m_owner: Character
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(owner: Character) {
        
        m_owner = owner
        
        // make the border/background
        let cardBackground = SKTexture(imageNamed: "border.jpg")
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: CGSize(width: 200, height: 300))
        
        setScale(0.33)
        
        // TODO: make a different "foundation" image for the discard and don't hide it
        isHidden = true
    }
    
    func addCard(_ card: Card) {
        cards.append(card)
        card.isHidden = true
        if let tile = card.m_tile {
            tile.m_card = nil
        }
        card.m_tile = nil
        // Lose any coins that were placed on this card
        card.cost?.emptyAll()
    }
}
