//
//  Tile.swift
//  Project11
//
//  Created by Scott Honnigford on 4/1/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class Tile : SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    init(row: Int, col: Int) {
        
        let side = 135
        
        let background = SKTexture(imageNamed: "tile.jpg")
        super.init(texture: background, color: UIColor(white: 0.5, alpha: 1.0), size: CGSize(width: side, height: side))
        
        if (row + col) % 2 == 0 {
            colorBlendFactor = 0.7
        }
        else {
            colorBlendFactor = 1.0
        }
        blendMode = SKBlendMode.Replace
        
        // allow the Card to intercept touches instead of passing them through the scene
        //userInteractionEnabled = true
        
        //setScale(0.20)
        position = CGPointMake(CGFloat(200 + (col * side)), CGFloat(100 + (row * side)))
        zPosition = -5
    }
}
