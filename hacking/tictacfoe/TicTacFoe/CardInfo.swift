//
//  CardInfo.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 5/10/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation

enum CardType: UInt32 {
    
    // melee units
    case spearman
    case miner
    case ogre
    case scout
    case blackMarketTrader
    case hoplite
    case goblinRaiders
    
    // ranged units
    case archer
    case axeThrower
    case tower
    //case RedDragon
    
    // spells
    case fireball
    case lightningStorm
    case massHeal
    
    case wall

    // special case for random function, not real choice
    case last
    
    static func random() -> CardType {
        let rand = arc4random_uniform(last.rawValue)
        return CardType(rawValue: rand)!
    }
}

enum CardProp {
    
    case spell
    
    // gold manipulation
    case startTurnGainGold1
    case thisTurnDiscount1
    
    // range
    case range1
    case range2
    case lineAttack
    
    // attack spells
    case unitDamageSpell
    case areaDamageSpell
    
    // other spells
    case massHeal2
    
    // movement related
    case trailblazer2
    case cannotMove
    case cannotAttack
    
    case actions2
    
    // card/hand manipulation
    case drawCard
    
    // TODO: this only applies to ranged attacks (eg. not when archer is defender) - is this what we want?
    case reduceRangeDamage1
}

class CardData {
    
    var image: String
    var scale: Float
    var health: Int
    var cost: Int
    var attack: Int
    var props: Set<CardProp>?
    
    init(i: String, s: Float, a: Int, h: Int, c: Int, p: Set<CardProp>?) {
        image = i
        scale = s
        health = h
        cost = c
        attack = a
        props = p
    }

}

class CardInfo {

    static var data = [CardType: CardData]()
    
    static func initInfo() {
        
        data[.spearman] =          CardData(i: "Spearman.png",            s: 0.25, a: 2, h: 2, c: 2, p: nil)
        data[.miner] =             CardData(i: "230px-Miner.png",         s: 0.60, a: 1, h: 1, c: 2, p: [.startTurnGainGold1])
        data[.archer] =            CardData(i: "archer.png",              s: 0.55, a: 1, h: 2, c: 3, p: [.range2])
        data[.fireball] =          CardData(i: "Fireball_2.png",          s: 0.13, a: 3, h: 0, c: 2, p: [.spell, .unitDamageSpell])
        data[.ogre] =              CardData(i: "ogre.png",                s: 0.25, a: 3, h: 6, c: 4, p: nil)
        data[.scout] =             CardData(i: "scout.jpg",               s: 0.60, a: 1, h: 2, c: 3, p: [.trailblazer2])
        data[.lightningStorm] =    CardData(i: "lightning.png",           s: 0.35, a: 2, h: 0, c: 3, p: [.spell, .areaDamageSpell])
        data[.axeThrower] =        CardData(i: "axe_thrower.jpg",         s: 0.15, a: 2, h: 2, c: 3, p: [.range1])
        data[.blackMarketTrader] = CardData(i: "black_market_trader.png", s: 0.20, a: 1, h: 2, c: 2, p: [.thisTurnDiscount1])
        data[.hoplite] =           CardData(i: "hop.png",                 s: 0.50, a: 2, h: 3, c: 3, p: [.reduceRangeDamage1])
        data[.massHeal] =          CardData(i: "heal_spell.png",          s: 0.50, a: 0, h: 0, c: 2, p: [.spell, .massHeal2, .drawCard])
        data[.tower] =             CardData(i: "Bow_tower.png",           s: 1.20, a: 1, h: 5, c: 4, p: [.range2, .cannotMove])
        data[.wall] =              CardData(i: "stone_wall.png",          s: 0.60, a: 0, h: 3, c: 1, p: [.cannotAttack, .cannotMove, .reduceRangeDamage1])
        data[.goblinRaiders] =     CardData(i: "goblin_raiders.png",      s: 0.45, a: 2, h: 3, c: 4, p: [.actions2])
    }
    
}
