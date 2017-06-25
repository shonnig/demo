//
//  GameCard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit


class GameCard: TTLCard {
    
    static let sFont = "ArialRoundedMTBold"
    static let sFrameImage = "cardfront.png"
    static let sWidth = 140
    static let sHeight = 200
    
    var mTitle: SKLabelNode?
    
    init() {
    
        // TODO: Input parameters, or from a data structure?
        let titleText = "Foo"
        
        super.init(texture: SKTexture(imageNamed: GameCard.sFrameImage), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))
        // TODO: investigate this?
        colorBlendFactor = 0.2
        
        // Add the title label
        mTitle = SKLabelNode(fontNamed: GameCard.sFont)
        
        if let title = mTitle {
            title.text = titleText
            title.fontColor = UIColor.black
            title.fontSize = 16
            //title.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            title.zPosition = 10
            title.position = CGPoint(x: 0, y: -15)
            addChild(title)
        }
        
        if let scene = GameScene.sCurrentScene {
            // TODO: don't like this
            scene.addChild(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
