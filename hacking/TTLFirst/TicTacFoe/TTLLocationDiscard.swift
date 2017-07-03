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
    
    var mCards: [TTLCard] = []
    
    var mInProgress = false
    
    override func addCard(_ card: TTLCard) {
        mCards.append(card)
        card.setLocation(self)
        throwIn(card)
    }
    
    override func removeCard(_ card: TTLCard) {
        if let index = mCards.index(of: card) {
            mCards.remove(at: index)
            card.setLocation(nil)
        }
    }
    
    func throwIn(_ card: TTLCard) {
        
    }
    
}
