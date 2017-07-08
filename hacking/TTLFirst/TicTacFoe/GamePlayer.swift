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
    
    var mMana = 0 {
        didSet {
            manaLabel?.text = "\(mMana)"
        }
    }
    
    var manaLabel: SKLabelNode?
    
    // TODO: Move some of these to TTLPlayer?
    let mHand = GameLocationHand()
    
    let mDiscard = GameLocationDiscard()
    
    let mDeck = GameLocationDeck()
    
    func setup() {
        
        manaLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        manaLabel!.text = "\(mMana)"
        manaLabel!.fontSize = 30
        manaLabel!.fontColor = UIColor.yellow
        manaLabel!.zPosition = ZPosition.hudUI.rawValue
        manaLabel!.position = CGPoint(x: 50,y: 160)
        GameScene.sCurrentScene?.addChild(manaLabel!)
        
        mDeck.position = CGPoint(x: 900, y: 70)
        mDiscard.position = CGPoint(x: 100, y: 70)
        if let scene = GameScene.sCurrentScene {
            scene.addChild(mDeck)
            scene.addChild(mDiscard)
        }
    }
    
    func updateValidChoices() {
        mHand.updateValidChoices(mMana)
    }
    
    func drawUpTo(_ num: Int) {
        
        while mHand.getSize() < num {
            if let topDeck = mDeck.draw() {
                mHand.addCard(topDeck)
            } else {
                if mDiscard.getSize() < 1 {
                    // No cards left in deck or discard, out of luck!
                    break
                } else {
                    // Shuffle discard into deck
                    let cards = mDiscard.removeAll()
                    mDeck.addCards(cards)
                    mDeck.shuffle()
                }
            }
        }
        
        mHand.repositionCards()
    }
}
