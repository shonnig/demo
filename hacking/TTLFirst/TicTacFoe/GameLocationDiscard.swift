//
//  GameLocationDiscard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/24/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class GameLocationDiscard: TTLLocationDiscard {
    
    init() {
        super.init(texture: SKTexture(imageNamed: "discard.png"), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))
        // TODO: investigate this?
        //colorBlendFactor = 0.2
        zPosition = 500
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isValidPlay(_ card: TTLCard) -> UIColor {
        return UIColor.red
    }
    
    override func play(_ card: TTLCard) {
        // player is discarding the card
        card.mLocation?.removeCard(card)
        addCard(card)
        card.isHidden = true   // TODO: animate card into discard pile... maybe fade over time?
        GameScene.getPlayer().mMana += 1
    }
}
