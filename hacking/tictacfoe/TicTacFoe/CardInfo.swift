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
    
    static func random() -> CardType {
        // Update as new enumerations are added
        let maxValue = Miner.rawValue
        
        let rand = arc4random_uniform(maxValue + 1)
        return CardType(rawValue: rand)!
    }
}

enum CardProp {
    case startTurnGainGold1
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
        
    }
    
}