//
//  GameScene.swift
//  Project11
//
//  Created by Hudzilla on 15/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit

// Extend SKNode with a function that should probably already exist...
extension SKNode
{
    func runAction( action: SKAction!, withKey: String!, optionalCompletion: dispatch_block_t? )
    {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.runBlock( completion )
            let compositeAction = SKAction.sequence([ action, completionAction ])
            runAction( compositeAction, withKey: withKey )
        }
        else
        {
            runAction( action, withKey: withKey )
        }
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*
	var scoreLabel: SKLabelNode!

	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	var editLabel: SKLabelNode!

	var editingMode: Bool = false {
		didSet {
			if editingMode {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}
    */
    
    
    var hand: Hand?
    
    var deck: Deck?
    
    var tiles = [Tile]()

    /*
    override init() {
        hand = Hand()
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    override func update(currentTime: CFTimeInterval) {
        
        deck!.update(currentTime)
        
        // TODO: currently, updating in this order will give a move advantage to player on the bottom!
        for tile in tiles {
            if tile.occupiedBy != nil {
                tile.occupiedBy!.update(currentTime)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -100
		addChild(background)

        
        // Player's hand
        hand = Hand(_isPlayer: true)
        
        for row in 0...3 {
            for col in 0...4 {
                let tile = Tile(_row: row, _col: col)
                addChild(tile)
                tiles.append(tile)
            }
        }
        
        // Player's deck
        deck = Deck(_isPlayer: true)
        deck!.position = CGPointMake(900,50)
        addChild(deck!)
        
        // TODO: temp? have a starting hand of 3? One card will be drawn right away because timer init right now
        deck!.drawCard()
        deck!.drawCard()
        
        
        // TODO: put enemies on the board to test against
        var card = Card(_isPlayer: false, imageNamed: "Spearman.png", imageScale: 0.25)
        card.position = CGPointMake(900,1100)
        addChild(card)
        card.moveFromTileToTile(tiles[15], toTile: tiles[18])
        card.attackInterval = 2.5
        
        card = Card(_isPlayer: false, imageNamed: "Spearman.png", imageScale: 0.25)
        card.position = CGPointMake(900,1100)
        addChild(card)
        card.moveFromTileToTile(tiles[15], toTile: tiles[16])
        card.attackInterval = 2

    }

}
