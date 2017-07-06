//
//  TTLLocationDeck.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLLocationDeck: TTLLocation {
    
    override func addCard(_ card: TTLCard) {
        mCards.append(card)
        card.setLocation(self)
        card.isHidden = true
        card.position = position
        sizeUpdated()
    }
    
    func addCards(_ cards: [TTLCard]) {
        mCards += cards
        sizeUpdated()
        for card in cards {
            card.isHidden = true
            card.position = position
        }
    }
    
    override func removeCard(_ card: TTLCard) {
        if let index = mCards.index(of: card) {
            mCards.remove(at: index)
            card.setLocation(nil)
            sizeUpdated()
        }
    }
    
    func shuffle() {
        mCards = mCards.shuffled()
    }
    
    func draw() -> TTLCard? {
        if mCards.count > 0 {
            let card = mCards.remove(at: 0)
            sizeUpdated()
            return card
        } else {
            return nil
        }
    }
}
