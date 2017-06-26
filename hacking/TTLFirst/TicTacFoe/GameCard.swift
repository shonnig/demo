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
    
    var mCost = 0
    
    var mTitleLabel: MKOutlinedLabelNode?
    
    var mCostLabel: MKOutlinedLabelNode?
    
    init() {
    
        // TODO: Input parameters, or from a data structure?
        let titleText = "Foo"
        mCost = Int(arc4random_uniform(UInt32(5)))
        
        super.init(texture: SKTexture(imageNamed: GameCard.sFrameImage), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))
        // TODO: investigate this?
        colorBlendFactor = 0.2
        
        // Add the title label
        mTitleLabel = MKOutlinedLabelNode(fontNamed: GameCard.sFont, fontSize: 16)
        if let title = mTitleLabel {
            title.outlinedText = titleText
            title.fontColor = UIColor.white
            title.borderColor = UIColor.black
            title.borderWidth = 0
            //title.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            title.zPosition = 10 // TODO
            title.position = CGPoint(x: 0, y: -15)
            addChild(title)
        }
        
        // Add the cost label
        mCostLabel = MKOutlinedLabelNode(fontNamed: GameCard.sFont, fontSize: 20)
        if let cost = mCostLabel {
            cost.outlinedText = "\(mCost)"
            cost.fontColor = UIColor.white
            cost.borderColor = UIColor.black
            cost.borderWidth = 0
            cost.zPosition = 10
            cost.position = CGPoint(x: -55, y: 80)
            addChild(cost)
        }
        
        // TODO: testing a glow effect
        let node = SKEffectNode()
        let glowFilter = GlowFilter()
        glowFilter.glowColor = UIColor.blue.withAlphaComponent(0.5)
        glowFilter.inputRadius = 20
        node.shouldRasterize = true
        node.filter = glowFilter
        addChild(node)
        
        
        if let scene = GameScene.sCurrentScene {
            // TODO: don't like this
            scene.addChild(self)
        }
        
        // allow the Card to intercept touches instead of passing them through the scene
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
