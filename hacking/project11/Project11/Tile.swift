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
    
    static var currentHighlight: Tile?
    
    var row: Int = 0
    var col: Int = 0
    let side = 135
    
    // Card currently occupying the tile
    var occupiedBy: Card?
    
    // sprite for highlight effect
    var glowNode: SKSpriteNode?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_row: Int, _col: Int) {
        
        row = _row
        col = _col
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: side, height: side))
        
        // make checkerboard pattern to tell tiles apart
        if (row + col) % 2 == 0 {
            colorBlendFactor = 0.7
        }
        else {
            colorBlendFactor = 1.0
        }
        blendMode = SKBlendMode.Replace
        
        // TODO: will we want this?
        //userInteractionEnabled = true

        position = CGPointMake(CGFloat(300 + (col * side)), CGFloat(200 + (row * side)))
        zPosition = -10
        
        // Create the highlight node
        initHighlight()
    }
    
    func initHighlight() {
        // create a copy of our original node create the glow effect
        glowNode = SKSpriteNode(color: UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5), size: CGSize(width: side, height: side))
        glowNode!.setScale(1.1)
        // Make the effect go just under this tile (but above others)
        glowNode!.zPosition = -1
        glowNode!.hidden = true
        self.addChild(glowNode!)
    }
    
    func addHighlight() {
        
        // There can be only one
        if Tile.currentHighlight != self {
            Tile.currentHighlight?.removeHighlight()
            Tile.currentHighlight = self
        }
        
        // Need to raise the highlighted tile above the others so the highlight is below this tile but above others
        zPosition = -5
        glowNode?.hidden = false
        
        // Green - empty and can be placed, red - occupied and can't
        // TODO: these rules need to be more complex (side of the board, etc.)
        if (occupiedBy != nil) {
            glowNode?.color = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        } else {
            glowNode?.color = SKColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        }
    }
    
    func removeHighlight() {
        Tile.currentHighlight = nil
        zPosition = -10
        glowNode?.hidden = true
    }
}
