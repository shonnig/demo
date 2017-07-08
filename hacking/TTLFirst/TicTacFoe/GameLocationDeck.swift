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
    
    var countLabel: SKLabelNode?
    
    init() {
        
        super.init(texture: SKTexture(imageNamed: "cardback.jpg"), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))

        zPosition = 500
        
        countLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        countLabel!.text = "\(getSize())"
        countLabel!.fontSize = 20
        countLabel!.fontColor = UIColor.yellow
        countLabel!.zPosition = ZPosition.hudUI.rawValue
        countLabel!.position = CGPoint(x: 40, y: -60)
        addChild(countLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeUpdated() {
        countLabel!.text = "\(getSize())"
    }
}
