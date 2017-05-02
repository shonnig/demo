//
//  HeroInfo.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 2/14/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation

enum HeroType: UInt32 {
    
    // melee units
    case barbarian
    case archer
    case sword_wizard
    case healer
    case alchemist
    case bard
    case necromancer
    case shield_knight
    
    // special case for random function, not real choice
    case last
    
    static func random() -> HeroType {
        let rand = arc4random_uniform(last.rawValue)
        return HeroType(rawValue: rand)!
    }
}

enum HeroProp {
    
    case foo
    case bar
}

class HeroData {
    
    var image: String
    var health: Int
    var facingRight: Bool
    var props: Set<HeroProp>?
    var deck: [CardId]?
    
    init(i: String, r: Bool, h: Int, p: Set<HeroProp>?, d: [CardId]) {
        image = i
        facingRight = r
        health = h
        props = p
        deck = d
    }
    
}

class HeroInfo {
    
    static var data = [HeroType: HeroData]()
    
    static func initInfo() {
        
        data[.barbarian] =      HeroData(i: "barbarian.png",                    r: false, h: 16, p: nil,       d: [.bash, .bash, .bash, .crush, .crush, .crush])
        data[.archer] =         HeroData(i: "archer.png",                       r: false, h: 13, p: [.foo],    d: [.snipe, .snipe, .snipe, .snipe, .rainOfArrows, .rainOfArrows])
        data[.sword_wizard] =   HeroData(i: "sword_wizard.png",                 r: false, h: 12, p: nil,       d: [.slice, .slice, .stab, .stab, .burnThemAll, .burnThemAll])
        data[.healer] =         HeroData(i: "healer.png",                       r: true,  h: 11, p: nil,       d: [.slice, .slice, .massHeal, .massHeal, .massHeal, .massHeal])
        data[.alchemist] =      HeroData(i: "alchemist.png",                    r: true,  h: 11, p: nil,       d: [.burnThemAll, .burnThemAll, .burnThemAll, .burnThemAll, .massHeal, .massHeal])
        data[.bard] =           HeroData(i: "bard.png",                         r: true,  h: 13, p: [.foo],    d: [.snipe, .snipe, .snipe, .slice, .slice, .slice])
        data[.necromancer] =    HeroData(i: "necromancer.png",                  r: false, h: 12, p: nil,       d: [.slice, .slice, .stab, .stab, .stab, .stab])
        data[.shield_knight] =  HeroData(i: "shield_knight.png",                r: false, h: 15, p: nil,       d: [.slice, .slice, .stab, .stab, .crush, .crush])
    }
    
}
