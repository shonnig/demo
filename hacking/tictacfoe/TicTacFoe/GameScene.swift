//
//  GameScene.swift
//  Project11
//
//  Created by Hudzilla on 15/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit


#if falses
// Extend SKNode with a function that should probably already exist...
extension SKNode
{
    func runAction( _ action: SKAction!, withKey: String!, optionalCompletion: ()->()? )
    {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run( completion )
            let compositeAction = SKAction.sequence([ action, completionAction ])
            run( compositeAction, withKey: withKey )
        }
        else
        {
            run( action, withKey: withKey )
        }
    }
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
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
    
    var round: Int = 0 {
        didSet {
            roundLabel.text = "Round \(round)"
        }
    }
    
    var roundLabel: SKLabelNode!
    
    func newTurn() {
        
        // clear any gold discounts
        currentTurn?.otherPlayer!.goldDiscount = 0
        
        // move end turn button TODO: this is just a quick and dirty thing for now
        turnButton!.position.y = (currentTurn?.turnButtonY)!
        
        // Do card turn ends
        for tile in tiles {
            if tile.occupiedBy != nil {
                let card = tile.occupiedBy!
                if card.player.isPlayer != currentTurn?.isPlayer {
                    card.endTurn()
                }
            }
        }
        
        // Score points for every tile owned above a certain number at the end of the turn
        currentTurn?.otherPlayer!.score += (currentTurn?.otherPlayer!.getScorePoints())!
        
        // Draw a card for player's new turn
        currentTurn!.deck!.drawCard()
        
        // Give them gold for turn
        currentTurn!.gold += currentTurn!.goldPerTurn
        
        // Increment investments and possibly update gold per turn for player
        currentTurn?.investments += 1
        if currentTurn?.investments >= currentTurn?.goldPerTurn {
            currentTurn?.goldPerTurn += 1
            currentTurn?.investments = 0
        }
        
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
        
        // increment round number
        if currentTurn!.isPlayer {
            round += 1
        }
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
            } else if row == 3 || row == 4 {
                p = opponent!
            }
            
            for col in 0...Tile.maxColumns - 1 {
                let tile = Tile(_row: row, _col: col, _owner: p)
                addChild(tile)
                tiles.append(tile)
            }
        }
        
        // Add turn number display
        roundLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        roundLabel.text = "Round \(round)"
        roundLabel.fontSize = 40
        roundLabel.fontColor = UIColor.greenColor()
        roundLabel.zPosition = ZPosition.HudUI.rawValue
        roundLabel.position = CGPointMake(125,400)
        addChild(roundLabel)
        
        // *** Temp init game state
        
        // TODO: temp 10 cards in deck
        
        player!.deck!.addCard(.GoblinRaiders)
        opponent!.deck!.addCard(.Tower)
        
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
        opponent!.gold += 1
        
        currentTurn = player
    }

}
#endif

enum ZPosition: CGFloat {
    
    case background = -1000
    case bot = 0
    
}

class GameScene: SKScene {
    
    var firstBot: Bot?
    
    var secondBot: Bot?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx:0, dy:0)
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = ZPosition.background.rawValue
        addChild(background)
        
        //self.physicsBody = SKPhysicsBody(bodyWithEdgeLoopFromRect: self.frame)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        
        firstBot = Bot()
        firstBot?.position = CGPoint(x: 512, y: 384)
        firstBot?.zPosition = ZPosition.bot.rawValue
        addChild(firstBot!)
        
        secondBot = Bot()
        secondBot?.position = CGPoint(x: 512, y: 512)
        secondBot?.zPosition = ZPosition.bot.rawValue
        addChild(secondBot!)
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
        firstBot?.physicsBody?.applyForce(CGVector(dx: 0.0, dy: 100.0))
        
    }

}

