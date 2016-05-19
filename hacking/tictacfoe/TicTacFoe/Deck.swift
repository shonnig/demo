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
    
    var player: Player
    
    let drawInterval:CFTimeInterval = 5
    
    var cards = [Card]()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_player: Player) {
        
        player = _player
        
        var bgColor: UIColor
        
        if player.isPlayer {
            bgColor = UIColor.blueColor()
            
        } else {
            bgColor = UIColor.greenColor()
        }
        
        super.init(texture: SKTexture(imageNamed: "border.jpg"), color:bgColor, size: CGSize(width: 200, height: 300))
        colorBlendFactor = 0.1
        
        setScale(0.33)
    }
    
    func addCard(type: CardType) {
        let card = Card(_player: player, type: type)
        card.position = position
        card.hidden = true
        scene!.addChild(card)
        cards.append(card)
        card.location = .Deck
        card.faceDown = true
    }
    
    func drawCard() {
        
        // Can never go beyond max hand size
        if player.hand!.isFull() {
            return
        }
        
        // Is the draw pile empty?
        if cards.count == 0 {
            // If discards is empty too, then return
            if player.discard!.cards.count == 0 {
                return
            }
            
            // put discard into draw pile and shuffle
            // TODO: animate this?
            cards = player.discard!.cards.shuffle().map( { card in
                card.hidden = true
                card.position = position
                card.location = .Deck
                return card
                } )
            player.discard!.cards = [Card]()
        }
        
        // remove top card of deck
        let card = cards.removeFirst()
        
        card.hidden = false
        card.zPosition = ZPosition.CardInHand.rawValue
        player.hand!.addCard(card)
        player.hand!.alignHand()
    }
    
}