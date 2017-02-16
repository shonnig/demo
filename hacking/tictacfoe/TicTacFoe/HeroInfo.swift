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
    case sword
    case spear
    
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
    var props: Set<HeroProp>?
    
    init(i: String, h: Int, p: Set<HeroProp>?) {
        image = i
        health = h
        props = p
    }
    
}

class HeroInfo {
    
    static var data = [HeroType: HeroData]()
    
    static func initInfo() {
        
        data[.sword] =          HeroData(i: "kaim_hero_handaxe.gif~c200.gif",               h: 2, p: nil)
        data[.spear] =          HeroData(i: "230px-Miner.png",                              h: 1, p: [.foo])
    }
    
}
