//
//  Card.swift
//  Project11
//
//  Created by Scott Honnigford on 3/31/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

// TODO: can Tile just include a Tile reference? Can get row and col from there and would be simpler to find Tile.
enum CardLocation {
    case hand
    // row and col
    case tile(Int, Int)
    case deck
    case discard
    case choice
}

class Card : SKSpriteNode {
    
    var props: [CardProp]
    
    var title: SKLabelNode
    
    var desc: [SKLabelNode]
    
    var cost: CoinChain?
    
    var rally: CoinChain?
    
    var m_tile: Tile?
    
    var m_owner: Character
    
    var mHand: Hand?
    
    // TODO: maybe make these into an enum?
    var enabledForRally = false
    var enabledForPlay = false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(type: CardId, owner: Character) {
        
        // Get card info
        let data = CardInfo.data[type]
        props = data!.props!
        
        m_owner = owner
        
        let font = "ArialRoundedMTBold"
        
        // Add the title label
        title = SKLabelNode(fontNamed: font)
        title.text = data?.name
        
        desc = []
        
        super.init(texture: SKTexture(imageNamed: "enemy_card.jpg"), color: UIColor.white, size: CGSize(width: GameScene.side, height: GameScene.side))
        // TODO: ?
        colorBlendFactor = 0.2
 
        // TODO: don't hardcode positions
        title.fontColor = UIColor.black
        title.fontSize = 20
        title.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        title.position = CGPoint(x: 0, y: 50)
        addChild(title)
        
        
        // Add the description label(s)
        if let descriptions = data!.text {
            var y_pos = -15 + (descriptions.count * 8)
            for line in descriptions {
                let label = SKLabelNode(fontNamed: font)
                label.text = line
                desc.append(label)
                label.fontColor = UIColor.black
                label.fontSize = 12
                label.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
                label.position = CGPoint(x: 0, y: y_pos)
                addChild(label)
                y_pos -= 12
            }
        }
        
        if let coins = data?.cost {
            cost = CoinChain(compact: false, orange: coins[0], blue: coins[1],green: coins[2],yellow: coins[3])
            cost?.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            cost?.position = CGPoint(x: 0, y: 10 + (desc.count * 8))
            cost?.mCostForCard = self
            addChild(cost!)
        }
        
        if let coins = data?.rally {
            rally = CoinChain(compact: false, orange: coins[0],blue: coins[1],green: coins[2],yellow: coins[3])
            rally?.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            rally?.position = CGPoint(x: 0, y: -40)
            addChild(rally!)
        }
        
        // allow the Card to intercept touches instead of passing them through the scene
        isUserInteractionEnabled = true
    }
    
    func placeOnTile(tile: Tile, animate: Bool) {
        
        // TODO: temp? trying to fix bug
        if animate {
        //if false {
            let unZoom = SKAction.scale(to: 1.0, duration: 0.3)
            let moveTo = SKAction.move(to: tile.position, duration: 0.3)
            let removeHand = SKAction.run( { tile.owner?.hand = nil } )
            let play = SKAction.group([unZoom, moveTo])
            let all = SKAction.sequence([play, removeHand])
            run(all, withKey: "play")
        } else {
            setScale(1.0)
            position = tile.position
        }
        
        isHidden = false
        zPosition = ZPosition.inPlay.rawValue
        m_tile = tile
        tile.m_card = self
    }
    
    func hasProp(_ type: CardPropType) -> Bool {
        
        for p in props {
            if p.type == type {
                return true
            }
        }
        
        return false
    }
    
    func getProp(_ type: CardPropType) -> CardProp? {
        
        for p in props {
            if p.type == type {
                return p
            }
        }
        
        return nil
    }
    
    func getValidTargets(_ type: CardPropType) -> [Tile] {
        var targets = [Tile]()
        
        if let tile = m_tile, let player = tile.owner, let opp = player.otherPlayer {
            switch type {
            case .melee:
                // Check for an enemy immediately across from us
                if opp.mHeroTiles[tile.row].character != nil {
                    targets.append(opp.mHeroTiles[tile.row])
                } else {
                    // If no enemy immediately across, may choose from any enemy
                    for enemyTile in opp.mHeroTiles {
                        if enemyTile.character != nil {
                            targets.append(enemyTile)
                        }
                    }
                }
                break
            case .ranged:
                // May choose from any enemy
                for enemyTile in opp.mHeroTiles {
                    if enemyTile.character != nil {
                        targets.append(enemyTile)
                    }
                }
                break
            case .chaotic:
                // Pick a random enemy
                var validTargets = [Tile]()
                for enemyTile in opp.mHeroTiles {
                    if enemyTile.character != nil {
                        validTargets.append(enemyTile)
                    }
                }
                targets.append(validTargets.randomItem())
                break
            default:
                break
            }
        }
        
        return targets
    }
    
    // Called when the cost of an action has been filled
    //
    func resolve() {

        if let player = m_tile?.owner, let tile = m_tile  {
            
            let from = player.mHeroTiles[tile.row]
            
            // Suspend other sequences
            player.isResolving = true
        
            
            // Should only have one attack type at most
            var targets: [Tile]?
            var prop: CardProp?
            if hasProp(.melee) {
                targets = getValidTargets(.melee)
                prop = getProp(.melee)
            }
            if hasProp(.ranged) {
                targets = getValidTargets(.ranged)
                prop = getProp(.ranged)
            }
            if hasProp(.chaotic) {
                targets = getValidTargets(.chaotic)
                prop = getProp(.chaotic)
            }
            
            if let found = targets, let damage = prop?.values[0] {
                
                let from = player.mHeroTiles[tile.row]
                
                // Save off damage for when attack occurs
                // TODO: make a full blown attack class to save all the data we need?
                player.currentAttackDamage = damage
                
                // If only one target, just attack
                if found.count == 1 {
                    from.attackTile(found[0])
                }
                
                // If there are multiple targets, let player choose
                if found.count > 1 {
                    player.currentAttacker = from
                    for choice in found {
                        choice.enableForTarget()
                    }
                }
            }
            
            // AOE attack
            if hasProp(.aoe) {
                player.currentAttackDamage = (getProp(.aoe)?.values[0])!
                from.aoeAllTiles()
            }
            
            if hasProp(.aoeHeal) {
                let healAmount = (getProp(.aoeHeal)?.values[0])!
                from.aoeHealAllTiles(healAmount)
            }
            
        }
    }
    
    // After a card is resolved, and resulting attacks/etc. are completed, finish up with this function
    //
    func resolveComplete() {
        
        if let tile = m_tile, let player = tile.owner, let deck = tile.character?.deck {
            // Resume other sequences
            player.isResolving = false
            
            // Clear out state of a pending attack
            player.currentAttacker = nil
            player.currentAttackDamage = 0
            
            // Discard the card
            m_owner.discard?.addCard(self)
            
            // Don't bother drawing next hand if someone just won the game
            if player.lost == false && player.otherPlayer?.lost == false {
                
                // Draw a hand of 3 cards to choose next action from
                var drawn = [Card]()
                for _ in 0..<3 {
                    if let card = deck.drawCard() {
                        drawn.append(card)
                    }
                }
                player.hand = Hand(cards: drawn, player: player, pending: tile)
                
                // After a player resolves an action, their opponent may rally a card
                player.otherPlayer?.ralliesPending = 1
                player.otherPlayer?.enableActionsForRally()
                
                // Show "done" button so they may skip this if they want
                let gameScene = scene as! GameScene
                gameScene.doneButton?.isHidden = false
                gameScene.doneButton?.isUserInteractionEnabled = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Did player select this card while it's in their hand?
        if enabledForPlay {
            if let hand = mHand, let tile = mHand?.mPendingTile /*, let player = tile.owner*/ {
                
                // Move from hand to action tile
                hand.removeCard(self)
                placeOnTile(tile: tile, animate: true)
                
                // Discard other cards
                hand.discardAll()
                
                // Don't do this until end of animation, or we get race conditions
                //player.hand = nil
            }
            
            return
        }
        
        // If a hand is currently active, don't allow other choices behind it to interact
        if let player = m_tile?.owner {
            if player.hand != nil || player.otherPlayer?.hand != nil {
                return
            }
        }
        
        // Did player select this card to rally?
        if enabledForRally {
            
            if let tile = m_tile, let deck = m_tile?.character?.deck, let player = m_tile?.owner {
                
                tile.disableForRally()
                
                player.ralliesPending -= 1
                
                // If not waiting for any more rallies after this, disable all the remaining choices
                if player.ralliesPending <= 0 {
                    for tile in player.mHeroActionTiles {
                        tile.disableForRally()
                    }
                }

                // Discard the card
                m_owner.discard?.addCard(self)
                
                // Move rally coins to bag
                rally?.moveCoinsToChain(row: tile.row, new: player.bag)
                
                // Draw a hand of 3 cards to choose next action from
                var drawn = [Card]()
                for _ in 0..<3 {
                    if let card = deck.drawCard() {
                        drawn.append(card)
                    }
                }
                player.hand = Hand(cards: drawn, player: player, pending: tile)
            }
        }
    }
}
