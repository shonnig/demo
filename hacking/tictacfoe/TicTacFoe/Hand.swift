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

    var player: Player
    
    let maxSize = 5
    
    var cards = [Card]()
    
    init(_player: Player) {
        player = _player
    }
    
    func addCard(card: Card) {
        
        // TODO: need to enforce max hand size
        card.location = .Hand
        cards.append(card)
        card.faceDown = false
    }
    
    func removeCard(card: Card) {
        if let index = cards.indexOf(card) {
            cards.removeAtIndex(index)
        }
    }
    
    func size() -> Int {
        return cards.count
    }
    
    func isFull() -> Bool {
        return cards.count >= maxSize
    }
    
    func setFaceUp(doShow: Bool) {
        for card in cards {
            card.faceDown = !doShow
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
                card.removeActionForKey("snap")
            
                let snapToPosition = CGPoint(x: 300 + (i * 100), y: height)
                let snapTo = SKAction.moveTo(snapToPosition, duration: 0.3)
                card.runAction(snapTo, withKey: "snap")
            }
            i = i + 1
        }
    }
}