//
//  TTLLocation.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLLocation: SKSpriteNode {
    
    // Animation/action in progress
    var mInProgress = false
    
    var mCards: [TTLCard] = []
    
    func getSize() -> Int {
        return mCards.count
    }
    
    func sizeUpdated() {
    }
    
    func revert() {
    }
    
    func addCard(_ card: TTLCard) {
    }
    
    func removeCard(_ card: TTLCard) {
    }
    
    func isValidPlay(_ card: TTLCard) -> UIColor? {
        return nil
    }
    
    func play(_ card: TTLCard) {
        
    }
    
}
