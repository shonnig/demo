//
//  Character.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 2/12/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Character : SKSpriteNode {

    var maxHealth: Int
    
    var health: Int {
        didSet {
            statsLabel.outlinedText = "\(health)/\(maxHealth)"
            
            if health <= 0 {
                //die()
            }
            if health < maxHealth {
                statsLabel.fontColor = UIColor.red
            } else {
                statsLabel.fontColor = UIColor.white
            }
            
            //statsLabel.drawText()
        }
    }
    
    var deck: Deck?
    
    var discard: Discard?
    
    var hand: Hand?
    
    var statsLabel: MKOutlinedLabelNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imgName: String) {
        
        maxHealth = 1
        health = 1
        
        let font = "ArialRoundedMTBold"
        
        // Add the health label
        statsLabel = MKOutlinedLabelNode(fontNamed: font, fontSize: 20)
        statsLabel.fontColor = UIColor.white
        statsLabel.borderColor = UIColor.black
        statsLabel.borderWidth = 1
        statsLabel.outlinedText = "\(health)/\(maxHealth)"
        statsLabel.zPosition = ZPosition.cardLabel.rawValue - ZPosition.cardInHand.rawValue
        statsLabel.position = CGPoint(x: 40,y: -60)
        
        // Set size keeping original aspect ratio. Using height as maximum check for now.
        // TODO: use const/config for height
        let _texture = SKTexture(imageNamed: imgName)
        let reScale = GameScene.side / _texture.size().height
        super.init(texture: _texture, color: UIColor.white, size: CGSize(width: reScale * _texture.size().width, height: reScale * _texture.size().height))

        //statsLabel.drawText()
        addChild(statsLabel)
        
        //deck = Deck()
        //discard = Discard()
        //hand = Hand()
        
        //for _ in 0...9 {
        //    deck.addCard(type: CardType.random())
        //}
        
        
        //player!.deck!.shuffle()
        //opponent!.deck!.shuffle()
        
        // TODO: start with hand of 3?
        //for _ in 0...2 {
        //    player!.deck!.drawCard()
        //    opponent!.deck!.drawCard()
        //}
        
    }

    
}
