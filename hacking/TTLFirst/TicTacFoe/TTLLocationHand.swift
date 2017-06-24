//
//  TTLLocationHand.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation

class TTLLocationHand {
    
    
    // Adjust as needed?
    let mMaxHandSize = 7
    
    let mMaximumWidth = 512
    
    var mCards: [TTLCard] = []
    
    
    
    func addCard(_ card: TTLCard) {
        // check max hand size?
        
        mCards.append(card)
        repositionCards()
    }
    
    func repositionCards() {
        
        
    }
    
}
