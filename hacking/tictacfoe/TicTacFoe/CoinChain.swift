//
//  CoinChain.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 2/22/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class CoinChain : SKSpriteNode {

    
    var contents: [Coin]
    
    
    init(orange: Int, blue: Int, green: Int, purple: Int) {
        
        contents = []

        // TODO: fill in with real values
        super.init(texture: nil, color: UIColor.white, size: CGSize(width: 200, height: 30))
        isHidden = false
        
        // TODO: make routine so not to repeat code
        var x_pos = -120
        for _ in 0..<orange {
            let coin = Coin(_type: .orange)
            contents.append(coin)
            coin.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            coin.position = CGPoint(x: x_pos, y: 0)
            addChild(coin)
            x_pos += 35
        }
        
        for _ in 0..<blue {
            let coin = Coin(_type: .blue)
            contents.append(coin)
            coin.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            coin.position = CGPoint(x: x_pos, y: 0)
            addChild(coin)
            x_pos += 35
        }
        
        for _ in 0..<green {
            let coin = Coin(_type: .green)
            contents.append(coin)
            coin.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            coin.position = CGPoint(x: x_pos, y: 0)
            addChild(coin)
            x_pos += 35
        }
        
        for _ in 0..<purple {
            let coin = Coin(_type: .purple)
            contents.append(coin)
            coin.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
            coin.position = CGPoint(x: x_pos, y: 0)
            addChild(coin)
            x_pos += 35
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
