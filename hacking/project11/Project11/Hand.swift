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

    var cards = [Card]()
    
    func addCard(card: Card) {
        
        // TODO: need to enforce max hand size
        card.location = .Hand
        cards.append(card)
    }
    
    func removeCard(card: Card) {
        if let index = cards.indexOf(card) {
            cards.removeAtIndex(index)
        }
    }
    
    func size() -> Int {
        return cards.count
    }
    
    // animate all the cards in the hand into default place
    func alignHand() {
        
        var i = 0
        for card in cards {
            // kill current action in case alignHand gets called again before done
            card.removeActionForKey("snap")
            
            let snapToPosition = CGPoint(x: 300 + (i * 100), y: 50)
            let snapTo = SKAction.moveTo(snapToPosition, duration: 0.2)
            card.runAction(snapTo, withKey: "snap")
            i++
        }
    }
}