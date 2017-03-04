//
//  Tile.swift
//  Project11
//
//  Created by Scott Honnigford on 4/1/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKSpriteNode {

    enum Column {
        
        case heroAction
        case hero
        case allyAction
        case ally
        
    }
    
    var m_card: Card?
    
    var character: Character?
    
    static var currentHighlight: Tile?
    
    static let maxRows = 5
    static let maxColumns = 5
    
    var row: Int = 0
    var col: Int = 0
    
    var owner: Player?

    // Card currently occupying the tile
    var occupiedBy: Card?
    
    // sprite for highlight effect
    var glowNode: SKSpriteNode!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_row: Int, _col: Column, _owner: Player) {
        
        var x: Int
        row = _row
        
        if (_owner.isPlayer) {
            switch _col {
            case .heroAction:
                x = 100
            case .hero:
                x = 280
            default:
                x = 0
            }
        } else {
            switch _col {
            case .heroAction:
                x = 924
            case .hero:
                x = 744
            default:
                x = 0
            }
        }
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: GameScene.side, height: GameScene.side))
        position = CGPoint(x: CGFloat(x), y: CGFloat(650 - (row * 180)))
        zPosition = ZPosition.tile.rawValue
        owner = _owner
        isHidden = false
        
        glowNode = SKSpriteNode(texture: SKTexture(imageNamed: "multicolor_circle.png"), size: CGSize(width: Double(GameScene.side) * 1.7, height: Double(GameScene.side) * 1.7))
        self.addChild(glowNode)
        glowNode.position = CGPoint(x: 0, y: 0)
        glowNode.zPosition = ZPosition.tileHighlight.rawValue - ZPosition.tile.rawValue
        glowNode.isHidden = true
    }
    
    func enableForRally() {
        addHighlight()
        m_card?.enabledForRally = true
    }
    
    func disableForRally() {
        removeHighlight()
        m_card?.enabledForRally = false
    }
    
    func addHighlight() {
        
        glowNode.isHidden = false
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 5)
        glowNode.run(SKAction.repeatForever(rotate), withKey: "rotate")
        
        let grow = SKAction.scale(to: 1.1, duration: 1)
        let shrink = SKAction.scale(to: 0.9, duration: 1)
        let cycle = SKAction.sequence([grow, shrink])
        glowNode.run(SKAction.repeatForever(cycle), withKey: "pulse")
    }
    
    func removeHighlight() {
        glowNode.isHidden = true
        glowNode.removeAction(forKey: "rotate")
        glowNode.removeAction(forKey: "pulse")
    }
}
