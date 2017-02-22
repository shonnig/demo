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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init() {
        
        super.init(texture: SKTexture(imageNamed: "border.jpg"), color: UIColor.white, size: CGSize(width: 200, height: 300))
        colorBlendFactor = 0.2
        
        setScale(0.33)
    }
    
    func addCard(type: CardId) {
        let card = Card(type: type)
        card.position = position
        card.isHidden = true
        scene!.addChild(card)
        cards.append(card)
        card.location = .deck
    }
    
    func shuffle() {
        //cards.shuffle()
    }
    
    func drawCard() -> Card? {
        
        // Is the draw pile empty?
        if cards.count == 0 {
            // If discard is empty too, then return
            //if player.discard!.cards.count == 0 {
            return nil
            //}
            
            // put discard into draw pile and shuffle
            // TODO: animate this?
            //cards = player.discard!.cards.shuffle().map( { card in
            //cards = player.discard!.cards.map( { card in
            //    card.isHidden = true
            //    card.position = position
            //    card.location = .deck
            //    return card
            //    } )
            //player.discard!.cards = [Card]()
        }
        
        // remove top card of deck
        return cards.removeFirst()
    }
    
}
