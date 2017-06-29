//
//  GameLocationHand.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/24/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation

class GameLocationHand: TTLLocationHand {
    
    
    func updateValidChoices(_ mana: Int) {
        
        for card in mCards{
            let gc = card as! GameCard
            let valid = (gc.mCost <= mana)
            gc.setHighlight(valid)
            gc.setValidPlay(valid)
        }
    }
}
