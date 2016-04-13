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

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class GameScene: SKScene {

    var player: Player?
    
    var opponent: Player?
    
    var oppDiscard: Discard?
    
    var tiles = [Tile]()
    
    override func update(currentTime: CFTimeInterval) {
        
        player!.deck!.update(currentTime)
        opponent!.deck!.update(currentTime)
        
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
        
        for row in 0...3 {
            for col in 0...4 {
                let tile = Tile(_row: row, _col: col)
                addChild(tile)
                tiles.append(tile)
            }
        }
        
        player = Player(scene: self, _isPlayer: true)
        opponent = Player(scene: self, _isPlayer: false)
        
        // ***
        
        // TODO: temp 5 cards in deck
        player!.deck!.addCard()
        player!.deck!.addCard()
        player!.deck!.addCard()
        player!.deck!.addCard()
        player!.deck!.addCard()
        
        // TODO: temp draw 2 cards (one will get drawn right away because of timer
        player!.deck!.drawCard()
        player!.deck!.drawCard()
        
        // TODO: temp 5 cards in deck
        opponent!.deck!.addCard()
        opponent!.deck!.addCard()
        opponent!.deck!.addCard()
        opponent!.deck!.addCard()
        opponent!.deck!.addCard()
        
        // TODO: temp draw 2 cards (one will get drawn right away because of timer
        opponent!.deck!.drawCard()
        opponent!.deck!.drawCard()
        
        /*
        // TODO: put enemies on the board to test against
        var card = Card(_player: opponent!, imageNamed: "Spearman.png", imageScale: 0.25)
        card.position = CGPointMake(900,1100)
        addChild(card)
        card.moveFromTileToTile(tiles[15], toTile: tiles[18])
        card.attackInterval = 2.5
        
        card = Card(_player: opponent!, imageNamed: "Spearman.png", imageScale: 0.25)
        card.position = CGPointMake(900,1100)
        addChild(card)
        card.moveFromTileToTile(tiles[15], toTile: tiles[16])
        card.attackInterval = 2 
        */
    }

}
