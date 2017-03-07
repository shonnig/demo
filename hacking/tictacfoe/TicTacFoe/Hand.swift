//
//  Hand.swift
//  Project11
//
//  Created by Scott Honnigford on 4/3/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit


class Hand {
    
    //let maxSize = 5
    
    var mCards: [Card]
    
    var mOwner: Player
    
    var mPendingTile: Tile
    
    init(cards:[Card], player:Player, pending:Tile) {
        
        mCards = cards
        mOwner = player
        mPendingTile = pending
        
        var xPos = 225
        for card in cards {
            card.mHand = self
            card.isHidden = false
            card.zPosition = ZPosition.movingCard.rawValue
            card.setScale(0.0)
            card.position = CGPoint(x: xPos, y: 400)
            xPos += 300
            
            let wait = SKAction.wait(forDuration: 0.5)
            let zoom = SKAction.scale(to: 2.0, duration: 0.3)
            let enable = SKAction.run( { card.enabledForPlay = true })
            let showHand = SKAction.sequence([wait, zoom, enable])
            card.run(showHand, withKey: "showHand")
        }
    }
    
    /*
    func addCard(_ card: Card) {
        
        // TODO: need to enforce max hand size
        //card.location = .hand
        cards.append(card)
    }
    */
    
    func removeCard(_ card: Card) {
        if let index = mCards.index(of: card) {
            mCards.remove(at: index)
            card.mHand = nil
            card.enabledForPlay = false
        }
    }
    
    func discardAll() {
        
        if let discard = mPendingTile.character?.discard {
            for card in mCards {
                card.mHand = nil
                card.enabledForPlay = false
                discard.addCard(card)
            }
            mCards = [Card]()
        }
    }
}
