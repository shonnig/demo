//
//  TTLLocationHand.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLLocationHand {
    
    // Adjust as needed?
    let mMaxHandSize = 7
    let mMaximumWidth = 384
    let mMaximumSeparation = 150
    
    
    var mCards: [TTLCard] = []
    
    
    
    func addCard(_ card: TTLCard) {
        // TODO: check max hand size
        
        mCards.append(card)
        repositionCards()
    }
    
    // Find positions based on number of cards in hand,
    // and animate to new positions
    //
    func repositionCards() {
        let y = 100
        var separation = 0
        if mCards.count > 1 {
            separation = mMaximumWidth / (mCards.count - 1)
            if separation > mMaximumSeparation {
                separation = mMaximumSeparation
            }
        }
        var x = 512 - ((separation * (mCards.count - 1)) / 2)
        var z = CGFloat(1000) // TODO
        
        for card in mCards {
            card.zPosition = z
            card.moveTo(x,y)
            x += separation
            z += 100 // TODO
        }
    }
    
}
