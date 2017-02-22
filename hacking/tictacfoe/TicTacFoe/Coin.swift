//
//  Coin.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 2/16/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit


enum CoinType {
    
    case orange
    case blue
    case green
    case purple
    
}

class Coin : SKSpriteNode {

    var type: CoinType
    
    var empty = false
    
    init(_type: CoinType) {
        
        type = _type
        
        var img: String
        var color: UIColor
        
        switch type {
        case .orange:
            img = "horse.png"
            color = UIColor.orange
        case .blue:
            img = "rhino.png"
            color = UIColor.blue
        case .green:
            img = "bear.png"
            color = UIColor.green
        case .purple:
            img = "snake.png"
            color = UIColor.purple
        }
        
        super.init(texture: SKTexture(imageNamed: img), color: color, size: CGSize(width: 30, height: 30))
        colorBlendFactor = 0.7
        isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
