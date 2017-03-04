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

    var m_contents: [Coin]
    
    var m_compact: Bool
    
    var m_count: [CoinType : Int] {
        didSet {
            // Just update all the text
            m_label[.orange]?.text = "x \(m_count[.orange]!)"
            m_label[.blue]?.text = "x \(m_count[.blue]!)"
            m_label[.green]?.text = "x \(m_count[.green]!)"
            m_label[.yellow]?.text = "x \(m_count[.yellow]!)"
        }
    }
    
    var m_label: [CoinType : SKLabelNode]
    
    func addCoins(_type: CoinType, _num: Int, _isEmpty: Bool) {
        
        if m_compact {
            if let current = m_count[_type] {
                m_count[_type] = current + _num
            } else {
                m_count[_type] = _num
            }
        } else {
            var x_pos = -55 + (m_contents.count * 22)
            for _ in 0..<_num {
                let coin = Coin(_type: _type, _isEmpty: _isEmpty)
                m_contents.append(coin)
                coin.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
                coin.position = CGPoint(x: x_pos, y: 0)
                addChild(coin)
                x_pos += 22
            }
        }
    }
    
    func removeCoins(_type: CoinType, _num: Int) {
        
        // Only for compact display now
        if m_compact {
            if let current = m_count[_type] {
                m_count[_type] = current - _num
            }
        }
    }
    
    func initCompactCoin(_type: CoinType) {
        let x_pos = -55 + (m_contents.count * 65)
        let coin = Coin(_type: _type, _isEmpty: false)
        m_contents.append(coin)
        coin.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        coin.position = CGPoint(x: x_pos, y: 0)
        addChild(coin)
        
        let font = "ArialRoundedMTBold"
        
        // Add the title label
        let label = SKLabelNode(fontNamed: font)
        label.text = "x \(m_count[_type]!)"
        label.fontColor = UIColor.white
        label.fontSize = 20
        label.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        label.position = CGPoint(x: x_pos + 25, y: -8)
        m_label[_type] = label
        addChild(label)
    }
    
    init(compact: Bool, orange: Int, blue: Int, green: Int, yellow: Int) {
        
        m_contents = []
        m_count = [:]
        m_label = [:]
        
        m_compact = compact

        // TODO: fill in with real values
        // TODO: making a 1x1 pixel... find a better way?
        super.init(texture: nil, color: UIColor.white, size: CGSize(width: 1, height: 1))
        isHidden = false
        
        addCoins(_type: .orange, _num: orange, _isEmpty: true)
        addCoins(_type: .blue, _num: blue, _isEmpty: true)
        addCoins(_type: .green, _num: green, _isEmpty: true)
        addCoins(_type: .yellow, _num: yellow, _isEmpty: true)
        
        // Compact shows each coin type with "x N"
        if compact {
            initCompactCoin(_type: .orange)
            initCompactCoin(_type: .blue)
            initCompactCoin(_type: .green)
            initCompactCoin(_type: .yellow)
        }
    }
    
    func setEmpty(_type: CoinType, _isEmpty: Bool) {
        
        // Loop through until we find a coin of the right type, but isn't in this state yet
        for coin in m_contents {
            if coin.type != _type {
                continue
            }
            
            if coin.empty == _isEmpty {
                continue
            }
            
            coin.empty = _isEmpty
            break
        }
    }
    
    // NOTE: only supported from rally costs to bags (compact) right now
    func moveCoinsToChain(row: Int, new: CoinChain) {
        
        var delay = 0.0
        for coin in m_contents {
            
            let newCoin = Coin(_type: coin.type, _isEmpty: false)
            
            if let scene = coin.scene, let scenePos = coin.positionInScene {
                
                // Find where the matching coin in the bag is
                var toPos: CGPoint?
                for dest in new.m_contents {
                    if dest.type == coin.type {
                        toPos = dest.positionInScene
                        break
                    }
                }
                
                // Animate it to the bag
                if let to = toPos {
                    newCoin.position = scenePos
                    scene.addChild(newCoin)
                    let wait = SKAction.wait(forDuration: delay)
                    let moveTo = SKAction.move(to: to, duration: (0.8 / Double(row + 1)))
                    let remove = SKAction.removeFromParent() // I've verified this deletes the node
                    let increment = SKAction.run( { new.addCoins(_type: coin.type, _num: 1, _isEmpty: false) })
                    let rally = SKAction.sequence([wait, moveTo, remove, increment])
                    newCoin.run(rally, withKey: "rally")
                    delay += 0.3
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
