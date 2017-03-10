//
//  Player.swift
//  Project11
//
//  Created by Scott Honnigford on 4/12/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit


class Player {

    let isPlayer: Bool
    
    var mHeroActionTiles = [Tile]()
    
    var mHeroTiles = [Tile]()
    
    var hand: Hand?
    
    var bag: CoinChain
    
    // Players choose 2 cards to rally at beginning of game
    var ralliesPending = 2
    
    var otherPlayer: Player?
    
    var isPicking = false
    
    var isResolving = false
    
    var currentAttacker: Tile?
    
    var currentAttackDamage = 0
    
    var lost = false
    
    init(scene: GameScene, _isPlayer: Bool) {
        
        isPlayer = _isPlayer
        
        bag = CoinChain(compact: true, orange: 0,blue: 0,green: 0,yellow: 0)
        bag.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        bag.position = CGPoint(x: (isPlayer ? 250 : 700), y: 20)
        scene.addChild(bag)
        
        for row in 0...3 {
            
            let heroActionTile = Tile(_row: row, _col: .heroAction, _owner: self)
            mHeroActionTiles.append(heroActionTile)
            scene.addChild(heroActionTile)
            
            let heroTile = Tile(_row: row, _col: .hero, _owner: self)
            mHeroTiles.append(heroTile)
            scene.addChild(heroTile)
            
            let hero = Hero(type: HeroType.random())
            scene.addChild(hero)
            hero.placeOnTile(tile: heroTile)
            heroActionTile.character = hero
            
            // Initializing deck and discard here instead of in Hero.init(), because it needs to be added to the scene first.
            let deck = Deck(owner: hero)
            deck.isHidden = true
            scene.addChild(deck)
            hero.deck = deck
            hero.initDeck()
            
            let discard = Discard(owner: hero)
            discard.isHidden = true
            scene.addChild(discard)
            hero.discard = discard
            
            // Draw initial card and put on action tile
            if let card = deck.drawCard() {
                card.placeOnTile(tile: heroActionTile, animate: false)
                heroActionTile.enableForRally()
            }
        }
        
        bag.mOwner = self
    }
    
    func enableActionsForRally() {
        for tile in mHeroActionTiles {
            if tile.m_card != nil {
                tile.enableForRally()
            }
        }
    }
    
    func disableActionsForRally() {
        for tile in mHeroActionTiles {
            if tile.m_card != nil {
                tile.disableForRally()
            }
        }
    }
    
    // Looks at all the available actions, and for a given coin type, picks a random empty coin on one of those cards.
    // There may not be any of course.
    //
    func pickEmptyCoinOfType(type: CoinType) -> Card? {
        
        var numCards = 0
        
        var total = 0
        for tile in mHeroActionTiles {
            if let cost = tile.m_card?.cost {
                numCards += 1
                total += cost.numEmptyCoinsOfType(type: type)
            }
        }
        
        print("looking for an empty coin slot, and found \(numCards) cards available")
        
        // There may not be any empty of this type!
        if total > 0 {
            let roll = Int(arc4random_uniform(UInt32(total)))
            var threshold = 0
            for tile in mHeroActionTiles {
                if let card = tile.m_card, let cost = tile.m_card?.cost {
                    threshold += cost.numEmptyCoinsOfType(type: type)
                    if roll < threshold {
                        return card
                    }
                }
            }
        }
        
        return nil
    }
}
