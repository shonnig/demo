//
//  GameLocationBoard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 7/6/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class GameLocationBoard: TTLLocationBoard {
    
    init() {
        super.init(texture: nil, color: UIColor.white.withAlphaComponent(0.0), size:  CGSize(width: 1024, height: 300))
        zPosition = 500
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValidChoices(_ mana: Int) {
        // TODO: temp
        for card in mCards{
            let gc = card as! GameCard
            gc.setHighlight(nil)
            gc.setValidPlay(false)
        }
    }
    
    override func isValidPlay(_ card: TTLCard) -> UIColor? {
        if card.mLocation is GameLocationHand {
            if let gc = card as? GameCard {
                if gc.mCost <= GameScene.getPlayer().mMana {
                    return UIColor.green
                }
            }
        }
        
        return nil
    }
    
    override func play(_ card: TTLCard) {
        if isValidPlay(card) != nil {
            card.mLocation?.removeCard(card)
            addCard(card)
            // TODO: animate effect to demonstrate mana loss?
            if let gc = card as? GameCard {
                GameScene.getPlayer().mMana -= gc.mCost
            }
            updateValidChoices(0)
        }
    }
}
