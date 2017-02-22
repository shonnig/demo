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
    
    let maxSize = 5
    
    var cards = [Card]()
    
    init() {
    }
    
    func addCard(_ card: Card) {
        
        // TODO: need to enforce max hand size
        card.location = .hand
        cards.append(card)
    }
    
    func removeCard(_ card: Card) {
        if let index = cards.index(of: card) {
            cards.remove(at: index)
        }
    }
    
    func size() -> Int {
        return cards.count
    }
    
    func isFull() -> Bool {
        return cards.count >= maxSize
    }
    /*
    func setFaceUp(_ doShow: Bool) {
        for card in cards {
            card.faceDown = !doShow
            
            // Change card highlight state based on if they are playable
            if doShow && card.currentCost() <= player.gold {
                card.addHighlight()
            } else {
                card.removeHighlight()
            }
        }
    }
    
    func updateCostLabels() {
        for card in cards {
            card.updateCostLabel()
            if card.currentCost() <= player.gold {
                card.addHighlight()
            } else {
                card.removeHighlight()
            }
        }
    }
    
    // animate all the cards in the hand into default place
    func alignHand() {
        
        var height: Int
        
        if player.isPlayer {
            height = 50
        } else {
            height = 700
        }
        
        var i = 0
        for card in cards {
            
            // If card is currently being moved by user, don't snatch it away from them back to their hand
            if !card.isPickedUp {
                // kill current action in case alignHand gets called again before done
                card.removeAction(forKey: "snap")
            
                let snapToPosition = CGPoint(x: 300 + (i * 100), y: height)
                let snapTo = SKAction.move(to: snapToPosition, duration: 0.3)
                card.run(snapTo, withKey: "snap")
            }
            i = i + 1
        }
    }
     */
}
