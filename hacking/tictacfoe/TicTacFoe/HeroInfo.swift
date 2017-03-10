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
        
        data[.barbarian] =      HeroData(i: "barbarian.png",                    r: false, h: 16, p: nil,       d: [.bash, .bash, .bash, .bash, .bash, .bash])
        data[.archer] =         HeroData(i: "archer.png",                       r: false, h: 13, p: [.foo],    d: [.snipe, .snipe, .snipe, .snipe, .snipe, .snipe])
    }
    
}
