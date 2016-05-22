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

enum ZPosition: CGFloat {
    
    case Background = -1000
    
    case Tile = -100
    
    case TileHighlight = -20
    
    case HighlightedTile = -10
    
    case ButtonUI = 0
    
    case CardInHandHighlight = 5
    
    case CardInHand = 10
    
    case CardImage = 15
    
    case CardLabel = 20
    
    case CardBack = 30
    
    case DamageEffect = 100
    
    case MovingCardHighlight = 495 // TODO: don't think I need this, but leaving in for now...
    
    case MovingCard = 500
    
    case HudUI = 1000
    
}

class GameScene: SKScene {
    
    var player: Player?
    
    var opponent: Player?
    
    var turnButton: FTButtonNode?

    var currentTurn: Player? {
        didSet {
            newTurn()
        }
    }
    
    var tiles = [Tile]()
    
    
    func newTurn() {
        
        // move end turn button TODO: this is just a quick and dirty thing for now
        turnButton!.position.y = (currentTurn?.turnButtonY)!
        
        var tilesOwned = 0
        
        // Do card turn ends
        for tile in tiles {
            if tile.occupiedBy != nil {
                let card = tile.occupiedBy!
                if card.player.isPlayer != currentTurn?.isPlayer {
                    card.endTurn()
                }
            }
            
            // find tiles owned for scoring
            if tile.owner?.isPlayer == currentTurn?.otherPlayer!.isPlayer {
                tilesOwned += 1
            }
        }
        
        // Score points for every tile owned above ten at the end of the turn
        let scoreThreshold = 10
        if tilesOwned > scoreThreshold {
            currentTurn?.otherPlayer!.score += (tilesOwned - scoreThreshold)
        }
        
        // Draw a card for player's new turn
        currentTurn!.deck!.drawCard()
        currentTurn!.gold += 2
        
        // Do card turn starts
        for tile in tiles {
            if tile.occupiedBy != nil {
                let card = tile.occupiedBy!
                if card.player.isPlayer == currentTurn?.isPlayer {
                    card.startTurn()
                }
            }
        }
        
        currentTurn?.hand?.setFaceUp(true)
        currentTurn?.otherPlayer!.hand?.setFaceUp(false)
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        // TODO: will we need this?
    }
    
    override func didMoveToView(view: SKView) {
        
        // Init card info
        CardInfo.initInfo()
        
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = ZPosition.Background.rawValue
		addChild(background)
        
        let buttonImg = SKTexture(imageNamed: "End_Turn_Button.png")
        turnButton = FTButtonNode(normalTexture: buttonImg, selectedTexture: buttonImg, disabledTexture: buttonImg)
        turnButton!.position = CGPoint(x: 125, y: 200)
        turnButton!.zPosition = ZPosition.ButtonUI.rawValue
        turnButton!.userInteractionEnabled = true
        addChild(turnButton!)

        player = Player(scene: self, _isPlayer: true)
        opponent = Player(scene: self, _isPlayer: false)
        
        player!.otherPlayer = opponent
        opponent!.otherPlayer = player
        
        for row in 0...Tile.maxRows - 1 {
            var p: Player?
            if row == 0 || row == 1 {
                p = player!
            } else if row == 2 || row == 3 {
                p = opponent!
            }
            
            for col in 0...Tile.maxColumns - 1 {
                let tile = Tile(_row: row, _col: col, _owner: p)
                addChild(tile)
                tiles.append(tile)
            }
        }
        
        // *** Temp init game state
        
        // TODO: temp 5 cards in deck
        for _ in 0...4 {
            player!.deck!.addCard(CardType.random())
            opponent!.deck!.addCard(CardType.random())
        }
        //player!.deck!.shuffle()
        //opponent!.deck!.shuffle()
        
        // TODO: start with hand of 2?
        for _ in 0...1 {
            player!.deck!.drawCard()
            opponent!.deck!.drawCard()
        }
        
        currentTurn = player
    }

}
