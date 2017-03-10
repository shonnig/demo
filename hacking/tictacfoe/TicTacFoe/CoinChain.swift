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
    
    var mCostForCard: Card?
    
    var mOwner: Player?
    
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
    
    func emptyAll() {
        // Loop through until we find a coin of the right type, but isn't in this state yet
        for coin in m_contents {
            coin.empty = true
        }
    }
    
    func setEmpty(_type: CoinType, _isEmpty: Bool) {
        
        // While we're looking for a proper coin, see if all the coins are full
        var allFull = true
        var filled = false
        
        // Loop through until we find a coin of the right type, but isn't in this state yet
        for coin in m_contents {
            if !filled && coin.type == _type && coin.empty != _isEmpty {
                coin.empty = _isEmpty
                filled = true
            }
            
            allFull = allFull && !coin.empty
        }
        
        // TODO: check for card cost
        if allFull {
            if let card = mCostForCard {
                card.resolve()
            }
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
    
    func numEmptyCoinsOfType(type: CoinType) -> Int {
        var num = 0
        for coin in m_contents {
            if coin.type == type && coin.empty {
                num += 1
            }
        }
        return num
    }
    
    func getCompactCount() -> Int {
        var num = 0
        for (_,count) in m_count {
            num += count
        }
        return num
    }
    
    func getFirstCoinOfType(type: CoinType, empty: Bool) -> Coin? {
        for coin in m_contents {
            if coin.type == type && coin.empty == empty {
                return coin
            }
        }
        return nil
    }
    
    // Pick out a random coin from the bag and animate it to a free slot
    //
    func pickRandomCoin() {
        if let player = mOwner, let type = randomType() {
            if let startCoin = getFirstCoinOfType(type: type, empty: false), let scene = startCoin.scene, let scenePos = startCoin.positionInScene {
                
                player.isPicking = true
                
                let newCoin = Coin(_type: type, _isEmpty: false)
                newCoin.position = scenePos
                scene.addChild(newCoin)
                
                // Decrement bag
                removeCoins(_type: type, _num: 1)
                
                // Common "look at" animation
                let time = 0.6
                let moveTo = SKAction.move(to: CGPoint(x: 512, y: 384), duration: TimeInterval(time))
                let zoom = SKAction.scale(to: 3, duration: TimeInterval(time))
                let pull = SKAction.group([moveTo,zoom])
                let wait = SKAction.wait(forDuration: 0.4)
                let lookAt = SKAction.sequence([pull, wait])
                
                if let card = player.pickEmptyCoinOfType(type: type), let endCoin = card.cost?.getFirstCoinOfType(type: type, empty: true), let toPos = endCoin.positionInScene {
                    
                    // TODO: need to find bug where coins are going to the wrong place for some reason...
                    assert(card.isHidden == false)
                    assert(card.m_tile?.m_card == card)
                    
                    // We found a home for this coin
                    let moveTo = SKAction.move(to: toPos, duration: TimeInterval(time))
                    let zoom = SKAction.scale(to: 1, duration: TimeInterval(time))
                    let place = SKAction.group([moveTo,zoom])
                    let remove = SKAction.removeFromParent() // I've verified this deletes the node
                    let increment = SKAction.run( { card.cost?.setEmpty(_type: type, _isEmpty: false) })
                    let setDone = SKAction.run( { player.isPicking = false } )
                    let rally = SKAction.sequence([lookAt, place, remove, increment, setDone])
                    newCoin.run(rally, withKey: "pick")
                    
                } else {
                    // If can't find any empty to fill, animate that coin was picked, but wasted...
                    let fade = SKAction.fadeOut(withDuration: 0.4)
                    let remove = SKAction.removeFromParent() // I've verified this deletes the node
                    let setDone = SKAction.run( { player.isPicking = false } )
                    let rally = SKAction.sequence([lookAt, fade, remove, setDone])
                    newCoin.run(rally, withKey: "pick")
                }
            }
        }
    }
    
    func randomType() -> CoinType? {
        let roll = Int(arc4random_uniform(UInt32(getCompactCount())))
        var threshold = 0
        for (type,count) in m_count {
            threshold += count
            if roll < threshold {
                return type
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
