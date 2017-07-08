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
    static let sWidth = 100
    static let sHeight = 140
    static let sHighlightColor = UIColor.green
    
    var mCost = 0
    
    var mTitleLabel: MKOutlinedLabelNode?
    
    var mCostLabel: MKOutlinedLabelNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
    
        // TODO: Input parameters, or from a data structure?
        let titleText = "Foo"
        mCost = Int(arc4random_uniform(UInt32(5)))
        
        super.init()
        
        // Add the title label
        mTitleLabel = MKOutlinedLabelNode(fontNamed: GameCard.sFont, fontSize: 14)
        if let title = mTitleLabel {
            title.outlinedText = titleText
            title.fontColor = UIColor.white
            title.borderColor = UIColor.black
            title.borderWidth = 0
            //title.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            title.zPosition = 10 // TODO
            title.position = CGPoint(x: 0, y: -12)
            addChild(title)
        }
        
        // Add the cost label
        mCostLabel = MKOutlinedLabelNode(fontNamed: GameCard.sFont, fontSize: 16)
        if let cost = mCostLabel {
            cost.outlinedText = "\(mCost)"
            cost.fontColor = UIColor.white
            cost.borderColor = UIColor.black
            cost.borderWidth = 0
            cost.zPosition = 10
            cost.position = CGPoint(x: -40, y: 55)
            addChild(cost)
        }
    }
    

}
