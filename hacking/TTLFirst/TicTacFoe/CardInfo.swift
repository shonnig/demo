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
    case stab
    case crush
    case rainOfArrows
    case burnThemAll
    case massHeal

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
    case chaotic
    case aoeHeal
    
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
    
    var name: String
    var text: [String]?
    var props: [CardProp]?
    
    // orange, blue, green, yellow
    var cost: [Int]
    var rally: [Int]
    
    init(n: String, t: [String]?, p: [CardProp]?, c: [Int], r: [Int]) {
        name = n
        text = t
        props = p
        cost = c
        rally = r
    }

}

class CardInfo {

    static var data = [CardId: CardData]()
    
    static func initInfo() {
        
        data[.slice] =          CardData(n: "Slice",           t: ["Melee Attack:","5 damage"],                                   p: [CardProp(_type: .melee, _values: [5])],          c: [0, 0, 0, 3], r: [0, 0, 0, 3])
        data[.snipe] =          CardData(n: "Snipe",           t: ["Ranged Attack:", "4 damage"],                                 p: [CardProp(_type: .ranged, _values: [4])],         c: [0, 0, 3, 0], r: [0, 0, 4, 0])
        data[.bash] =           CardData(n: "Bash",            t: ["Attack a random", "enemy for 6 damage"],                      p: [CardProp(_type: .chaotic, _values: [6])],        c: [4, 0, 0, 0], r: [4, 0, 0, 0])
        data[.stab] =           CardData(n: "Stab",            t: ["Melee Attack:", "7 damage"],                                  p: [CardProp(_type: .melee, _values: [7])],          c: [2, 0, 0, 2], r: [2, 0, 0, 2])
        data[.crush] =          CardData(n: "Crush",           t: ["Attack a random", "enemy for 9 damage"],                      p: [CardProp(_type: .chaotic, _values: [9])],        c: [5, 0, 0, 0], r: [3, 0, 0, 0])
        data[.rainOfArrows] =   CardData(n: "Rain Of Arrows",  t: ["Deal 3 damage", "to all enemies"],                            p: [CardProp(_type: .aoe, _values: [3])],            c: [2, 0, 2, 2], r: [0, 0, 1, 2])
        data[.burnThemAll] =    CardData(n: "Burn Them All",   t: ["Deal 5 damage", "to all enemies"],                            p: [CardProp(_type: .aoe, _values: [5])],            c: [0, 0, 4, 2], r: [0, 0, 2, 0])
        data[.massHeal] =       CardData(n: "Mass Heal",       t: ["Heal all friendly", "heroes 3 health"],                       p: [CardProp(_type: .aoeHeal, _values: [3])],        c: [0, 4, 0, 0], r: [0, 3, 0, 0])
        
    }
    
}
