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
    
    let drawInterval:CFTimeInterval = 5
    
    var cards = [Card]()
    
    var m_owner: Character
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(owner: Character) {
        
        m_owner = owner
        
        super.init(texture: SKTexture(imageNamed: "border.jpg"), color: UIColor.white, size: CGSize(width: 200, height: 300))
        //colorBlendFactor = 0.2
        //setScale(0.33)
    }
    
    func addCard(type: CardId) {
        let card = Card(type: type, owner: m_owner)
        card.position = position
        card.isHidden = true
        scene!.addChild(card)
        cards.append(card)
        //card.location = .deck
    }
    
    func drawCard() -> Card? {
        
        // Is the draw pile empty? Then shuffle in the discard
        if cards.count == 0 {
            cards = (m_owner.discard?.cards)!
            m_owner.discard?.cards = []
            cards.shuffle()
        }
        
        if cards.count > 0 {
            // remove top card of deck
            return cards.removeFirst()
        } else {
            return nil
        }
    }
    
}
