//
//  GameLocationDeck.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/24/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class GameLocationDeck: TTLLocationDeck {
    
    init() {
        
        super.init(texture: SKTexture(imageNamed: "cardback.jpg"), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))
        // TODO: investigate this?
        colorBlendFactor = 0.2
        zPosition = 500
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
