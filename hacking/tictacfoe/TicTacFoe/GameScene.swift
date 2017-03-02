//
//  GameScene.swift
//  Project11
//
//  Created by Hudzilla on 15/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


// Extend SKNode with a function that should probably already exist...
/*
extension SKNode
{
    func runAction( _ action: SKAction!, withKey: String!, optionalCompletion: Optional<Any>)
    {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run( completion as! () -> Void )
            let compositeAction = SKAction.sequence([ action, completionAction ])
            run( compositeAction, withKey: withKey )
        }
        else
        {
            run( action, withKey: withKey )
        }
    }
}
*/

/*
extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
*/

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


enum ZPosition: CGFloat {
    
    case background = -1000
    
    case tile = -100
    
    case tileHighlight = -20
    
    case highlightedTile = -10
    
    case inPlay = -5
    
    case buttonUI = 0
    
    case cardInHandHighlight = 5
    
    case cardInHand = 10
    
    case cardImage = 15
    
    case cardLabel = 20
    
    case cardBack = 30
    
    case damageEffect = 100
    
    case movingCardHighlight = 495 // TODO: don't think I need this, but leaving in for now...
    
    case movingCard = 500
    
    case hudUI = 1000
    
}

class GameScene: SKScene {
    
    var player: Player?
    var opponent: Player?
    
    var tiles = [Tile]()
    
    static let side: CGFloat = 140.0
    
    var promptLabel: SKLabelNode?
    
    override func update(_ currentTime: TimeInterval) {
        
        if (player?.ralliesPending)! > 0 || (opponent?.ralliesPending)! > 0 {
            return
        }
        
        
        // If no coins in bag for either player, prompt for rallying again...
        
        // If there coins, start selecting now...
        
    }
    
    override func didMove(to view: SKView) {
        
        // Init card info
        CardInfo.initInfo()
        
        HeroInfo.initInfo()
        
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = ZPosition.background.rawValue
		addChild(background)
        
        /*
        let buttonImg = SKTexture(imageNamed: "End_Turn_Button.png")
        turnButton = FTButtonNode(normalTexture: buttonImg, selectedTexture: buttonImg, disabledTexture: buttonImg)
        turnButton!.position = CGPoint(x: 125, y: 200)
        turnButton!.zPosition = ZPosition.buttonUI.rawValue
        turnButton!.isUserInteractionEnabled = true
        addChild(turnButton!)
        */

        player = Player(scene: self, _isPlayer: true)
        opponent = Player(scene: self, _isPlayer: false)
        
        player!.otherPlayer = opponent
        opponent!.otherPlayer = player
        
        // Add label prompting action from player
        promptLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        promptLabel!.text = "Rally Two Actions"
        promptLabel!.fontSize = 30
        promptLabel!.fontColor = UIColor.yellow
        promptLabel!.zPosition = ZPosition.hudUI.rawValue
        promptLabel!.position = CGPoint(x: 500,y: 740)
        addChild(promptLabel!)
        
        // *** Temp init game state
        
        // TODO: temp 10 cards in deck
        /*
        player!.deck!.addCard(.goblinRaiders)
        opponent!.deck!.addCard(.tower)
        
        for _ in 0...9 {
            player!.deck!.addCard(CardType.random())
            opponent!.deck!.addCard(CardType.random())
        }
        //player!.deck!.shuffle()
        //opponent!.deck!.shuffle()
        
        // TODO: start with hand of 3?
        for _ in 0...2 {
            player!.deck!.drawCard()
            opponent!.deck!.drawCard()
        }
        
        // TODO: how to balance going second? Give an extra gold for now?
        //opponent!.gold += 1
        
        //currentTurn = player
        */
    }

}
