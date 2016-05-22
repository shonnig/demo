//
//  CardInfo.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 5/10/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation

enum CardType: UInt32 {
    case Spearman
    case Miner
    case Archer
    
    // special case for random function, not real choice
    case Last
    
    static func random() -> CardType {
        let rand = arc4random_uniform(Last.rawValue)
        return CardType(rawValue: rand)!
    }
}

enum CardProp {
    case startTurnGainGold1
    case range2
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
        
        data[.Spearman] = CardData(i: "Spearman.png",    s: 0.25, a: 2, h: 2, c: 2, p: nil)
        data[.Miner] =    CardData(i: "230px-Miner.png", s: 0.60, a: 1, h: 1, c: 2, p: [.startTurnGainGold1])
        data[.Archer] =   CardData(i: "archer.png",      s: 0.55, a: 1, h: 1, c: 3, p: [.range2])
        
    }
    
}