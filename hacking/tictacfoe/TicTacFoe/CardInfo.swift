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
    case Spearman
    case Miner
    case Ogre
    case Scout
    
    // ranged units
    case Archer
    case AxeThrower
    
    // spells
    case Fireball
    case LightningStorm

    // special case for random function, not real choice
    case Last
    
    static func random() -> CardType {
        let rand = arc4random_uniform(Last.rawValue)
        return CardType(rawValue: rand)!
    }
}

enum CardProp {
    
    case spell
    
    // gold manipulation
    case startTurnGainGold1
    
    // range
    case range1
    case range2
    
    // attack spells
    case unitDamageSpell
    case areaDamageSpell
    
    case trailblazer2
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
        
        data[.Spearman] =       CardData(i: "Spearman.png",    s: 0.25, a: 2, h: 2, c: 2, p: nil)
        data[.Miner] =          CardData(i: "230px-Miner.png", s: 0.60, a: 1, h: 1, c: 2, p: [.startTurnGainGold1])
        data[.Archer] =         CardData(i: "archer.png",      s: 0.55, a: 1, h: 1, c: 3, p: [.range2])
        data[.Fireball] =       CardData(i: "Fireball_2.png",  s: 0.13, a: 3, h: 0, c: 2, p: [.spell, .unitDamageSpell])
        data[.Ogre] =           CardData(i: "ogre.png",        s: 0.25, a: 3, h: 6, c: 4, p: nil)
        data[.Scout] =          CardData(i: "scout.jpg",       s: 0.60, a: 1, h: 2, c: 3, p: [.trailblazer2])
        data[.LightningStorm] = CardData(i: "lightning.png",   s: 0.35, a: 1, h: 0, c: 2, p: [.spell, .areaDamageSpell])
        data[.AxeThrower] =     CardData(i: "axe_thrower.jpg", s: 0.15, a: 2, h: 2, c: 3, p: [.range1])
    }
    
}