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
    
    var turnButton: FTButtonNode?
    
    var actionsLeft = 1

    var currentTurn: Player? {
        didSet {
            newTurn()
        }
    }
    
    var tiles = [Tile]()
    
    
    func newTurn() {
        
        // move end turn button TODO: this is just a quick and dirty thing for now
        turnButton!.position.y = (currentTurn?.turnButtonY)!
        
        // TODO: are we going to limit actions?
        // reset actions remaining to 1
        actionsLeft = 1
        
        // Draw a card for player's new turn
        currentTurn!.deck!.drawCard()
        currentTurn!.gold += 2
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /*
        player!.deck!.update(currentTime)
        opponent!.deck!.update(currentTime)
         */
        
        for tile in tiles {
            //tile.update(currentTime)
            
            if tile.occupiedBy != nil {
                let card = tile.occupiedBy!
                card.update(currentTime)
            }
        }
        
    }
    
    override func didMoveToView(view: SKView) {
        
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -100
		addChild(background)
        
        let buttonImg = SKTexture(imageNamed: "End_Turn_Button.png")
        turnButton = FTButtonNode(normalTexture: buttonImg, selectedTexture: buttonImg, disabledTexture: buttonImg)
        turnButton!.position = CGPoint(x: 125, y: 200)
        turnButton!.zPosition = 0
        turnButton!.userInteractionEnabled = true
        addChild(turnButton!)
        
        for row in 0...3 {
            for col in 0...3 {
                let tile = Tile(_row: row, _col: col)
                addChild(tile)
                tiles.append(tile)
            }
        }
        
        player = Player(scene: self, _isPlayer: true)
        opponent = Player(scene: self, _isPlayer: false)
        
        player!.otherPlayer = opponent
        opponent!.otherPlayer = player
        
        // *** Temp init game state
        
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
        
        currentTurn = player
    }

}