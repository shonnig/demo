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
    
    var nextDrawTime:CFTimeInterval
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_player: Player) {
        
        player = _player
        
        nextDrawTime = 0
        
        // make the border/background
        var cardBackground: SKTexture
        // TODO: use different colors or something eventually for different teams
        if player.isPlayer {
            cardBackground = SKTexture(imageNamed: "border.jpg")
        } else {
            cardBackground = SKTexture(imageNamed: "enemy_card.jpg")
        }
        
        super.init(texture: cardBackground, color: UIColor(white: 1.0, alpha: 0.0), size: CGSize(width: 200, height: 300))
        
        // allow the Card to intercept touches instead of passing them through the scene
        //userInteractionEnabled = true
        
        setScale(0.33)
    }
    
    func addCard(type: CardType) {
        let card = Card(_player: player, type: type)
        card.position = position
        card.hidden = true
        scene!.addChild(card)
        cards.append(card)
        card.location = .Deck
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
            //cards.shuffle()
        }
        
        // remove top card of deck
        let card = cards.removeFirst()
        
        card.hidden = false
        player.hand!.addCard(card)
        player.hand!.alignHand()
    }
    
    
    /*
    // TODO: should have a UI indicator for how long until next draw - should timer reset or hold if hand is full?
    // periodically draw a card
    func update(currentTime: CFTimeInterval) {
        
        if nextDrawTime < currentTime {
            drawCard()
            nextDrawTime = currentTime + drawInterval
        }
    }
     */
    
}