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
        //card.location = .hand
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
}
