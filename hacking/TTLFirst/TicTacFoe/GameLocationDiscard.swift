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
    
    var countLabel: SKLabelNode?
    
    init() {
        super.init(texture: SKTexture(imageNamed: "discard.png"), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))

        zPosition = 500
        
        countLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        countLabel!.text = "\(getSize())"
        countLabel!.fontSize = 30
        countLabel!.fontColor = UIColor.yellow
        countLabel!.zPosition = ZPosition.hudUI.rawValue
        countLabel!.position = CGPoint(x: 50, y: -80)
        addChild(countLabel!)
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
        // TODO: animate effect to demonstrate mana gain
        GameScene.getPlayer().mMana += 1
    }
    
    override func sizeUpdated() {
        countLabel!.text = "\(getSize())"
    }
}
