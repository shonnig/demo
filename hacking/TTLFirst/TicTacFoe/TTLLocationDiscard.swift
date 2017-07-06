//
//  TTLLocationDiscard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLLocationDiscard: TTLLocation {

    
    override func addCard(_ card: TTLCard) {
        mCards.append(card)
        card.setLocation(self)
        throwIn(card)
        sizeUpdated()
    }
    
    override func removeCard(_ card: TTLCard) {
        if let index = mCards.index(of: card) {
            mCards.remove(at: index)
            card.setLocation(nil)
            sizeUpdated()
        }
    }
    
    func removeAll() -> [TTLCard] {
        let cards = [TTLCard](mCards)
        mCards = []
        sizeUpdated()
        return cards
    }
    
    // TODO: for animating card going into discard. Rename?
    func throwIn(_ card: TTLCard) {
        card.isHidden = true
        card.position = position
    }
    
}
