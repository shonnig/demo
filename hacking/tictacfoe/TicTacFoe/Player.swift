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
    
    var tiles = [Tile]()
    
    var deck: Deck?
    
    var discard: Discard?
    
    var hand: Hand?
    
    var bag: CoinChain
    
    var ralliesPending = 2
    
    var otherPlayer: Player?
    
    init(scene: GameScene, _isPlayer: Bool) {
        
        isPlayer = _isPlayer
        
        bag = CoinChain(compact: true, orange: 0,blue: 0,green: 0,yellow: 0)
        bag.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        bag.position = CGPoint(x: (isPlayer ? 250 : 700), y: 20)
        scene.addChild(bag)
        
        for row in 0...3 {
            
            // TODO: Should attach actions, decks, discard, etc. to each hero instead of the player.
            let heroActionTile = Tile(_row: row, _col: .heroAction, _owner: self)
            tiles.append(heroActionTile)
            scene.addChild(heroActionTile)
            
            let heroTile = Tile(_row: row, _col: .hero, _owner: self)
            tiles.append(heroTile)
            scene.addChild(heroTile)
            
            let hero = Hero(type: HeroType.random())
            hero.position = heroTile.position
            scene.addChild(hero)
            heroTile.character = hero
            
            let deck = Deck(owner: hero)
            deck.isHidden = true
            scene.addChild(deck)
            hero.deck = deck
            
            let discard = Discard(owner: hero)
            discard.isHidden = true
            scene.addChild(discard)
            hero.discard = discard
            
            //let hand = Hand()
            //hero.hand = hand
            
            for _ in 0...9 {
                deck.addCard(type: CardId.random())
            }
            
            // Draw card and put on action tile
            if let card = deck.drawCard() {
                card.placeOnTile(tile: heroActionTile)
                heroActionTile.enableForRally()
            }
        }
    }
}
