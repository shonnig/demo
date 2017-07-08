//
//  TTLLocationBoard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 7/5/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLLocationBoard: TTLLocation {
    
    // Adjust as needed?
    let mMaxBoardSize = 6
    let mMaximumWidth = 576
    let mMaximumSeparation = 160
    
    override func addCard(_ card: TTLCard) {
        // TODO: check max hand size
        
        mCards.append(card)
        card.setLocation(self)
        card.isHidden = false
        repositionCards()      // TODO: do this here?
        sizeUpdated()
    }
    
    override func removeCard(_ card: TTLCard) {
        if let index = mCards.index(of: card) {
            mCards.remove(at: index)
            card.setLocation(nil)
            repositionCards() // TODO: do this here?
            sizeUpdated()
        }
    }
    
    override func revert() {
        repositionCards()
    }
    
    // Find positions based on number of cards in hand,
    // and animate to new positions
    //
    func repositionCards() {
        
        // No cards, nothing to do.
        if mCards.count == 0 {
            return
        }
        
        // TODO: not crazy about this. Just waiting X long for animations to
        // finish before allowing interactions with cards again. Should wait
        // for them all to be completed.
        if !mInProgress {
            mInProgress = true
            mCards[0].setInteract(false)
            let pause = SKAction.wait(forDuration: 0.5)
            let reenable = SKAction.run( { self.mCards[0].setInteract(true); self.mInProgress = false } )
            let sequence = SKAction.sequence( [pause, reenable] )
            mCards[0].run(sequence, withKey: "reenable")
        }
        
        let y = 300
        var separation = 0
        
        if mCards.count > 1 {
            separation = mMaximumWidth / (mCards.count - 1)
            if separation > mMaximumSeparation {
                separation = mMaximumSeparation
            }
        }
        
        var x = 512 - ((separation * (mCards.count - 1)) / 2)
        var z = 1000 // TODO
        
        for card in mCards {
            card.setZ(z)
            card.moveTo(x,y)
            x += separation
            z += 100 // TODO
        }
    }
    
}
