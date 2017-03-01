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
    case yellow
    
}

class Coin : SKSpriteNode {

    var type: CoinType
    
    var empty = true {
        didSet {
            if empty != oldValue {
                var cbf = 0.8
                if empty {
                    cbf = 0.1
                }
                // TODO: check if action is already in progress and cancel first?
                let action = SKAction.colorize(with: color, colorBlendFactor: CGFloat(cbf), duration: 1)
                run(action)
            }
        }
    }
    
    init(_type: CoinType, _isEmpty: Bool) {
        
        type = _type
        
        var img: String
        var color: UIColor
        
        switch type {
        case .orange:
            img = "hammer.png"
            color = UIColor.orange
        case .blue:
            img = "shield.png"
            color = UIColor(red: CGFloat(0.6), green: CGFloat(0.6), blue: CGFloat(0.9), alpha: CGFloat(1.0))
        case .green:
            img = "eye.png"
            color = UIColor.green
        case .yellow:
            img = "lightning.png"
            color = UIColor.yellow
        }
        
        super.init(texture: SKTexture(imageNamed: img), color: color, size: CGSize(width: 20, height: 20))
        empty = _isEmpty
        if empty {
            colorBlendFactor = 0.1
        } else {
            colorBlendFactor = 0.8
        }
        isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
