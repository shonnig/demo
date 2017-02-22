//
//  CardInfo.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 5/10/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation

enum Trigger {
    
    case play
    case complete
    case rally
    
}

enum CardId: UInt32 {
    
    case slice
    case bash
    case snipe
    
    /*
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
    */

    // special case for random function, not real choice
    case last
    
    static func random() -> CardId {
        let rand = arc4random_uniform(last.rawValue)
        return CardId(rawValue: rand)!
    }
}

enum CardPropType {
    
    case spell
    case melee
    case ranged
    case aoe
    case randomAttack
    
    /*
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
    */
}

class CardProp {
    var type: CardPropType
    var values: [Int]
    
    
    init(_type: CardPropType, _values: [Int]) {
        type = _type
        values = _values
    }
}

class CardData {
    
    //var image: String
    //var scale: Float
    //var health: Int
    //var cost: Int
    //var attack: Int
    
    // cost: coins
    // rally: coins
    // name: string
    // text: string
    
    var name: String
    var text: [String]?
    var props: [CardProp]?
    
    init(n: String, t: [String]?, p: [CardProp]?) {
        name = n
        text = t
        props = p
    }

}

class CardInfo {

    static var data = [CardId: CardData]()
    
    static func initInfo() {
        
        data[.slice] =              CardData(n: "Slice",                t: ["Melee Attack: 5","Another line","Last line"],                                                  p: [CardProp(_type: .melee, _values: [5])])
        data[.snipe] =              CardData(n: "Snipe",                t: ["Ranged Attack: 3"],                                                                            p: [CardProp(_type: .ranged, _values: [3])])
        data[.bash] =               CardData(n: "Bash",                 t: ["Attack a random", "enemy: 7"],                                                        p: [CardProp(_type: .randomAttack, _values: [7])])
        
        /*
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
        */
    }
    
}
