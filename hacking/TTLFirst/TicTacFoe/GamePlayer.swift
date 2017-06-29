//
//  GamePlayer.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class GamePlayer: TTLPlayer {
    
    var mMana = 3 // TODO
    
    let mHand = GameLocationHand()
    
    let mDiscard = GameLocationDiscard()
    
    let mDeck = GameLocationDeck()
    
    func setup() {
        
        mDeck.position = CGPoint(x: 900, y: 100)
        mDiscard.position = CGPoint(x: 100, y: 100)
        if let scene = GameScene.sCurrentScene {
            scene.addChild(mDeck)
            scene.addChild(mDiscard)
        }
    }
    
    func updateValidChoices() {
        mHand.updateValidChoices(mMana)
    }
    
}
