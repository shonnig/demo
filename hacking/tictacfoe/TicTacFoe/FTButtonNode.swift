//
//  FTButtonNode.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 5/1/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class FTButtonNode: SKSpriteNode {
    
    enum FTButtonActionType: Int {
        case TouchUpInside = 1,
        TouchDown, TouchUp
    }
    
    var isEnabled: Bool = true {
        didSet {
            if (disabledTexture != nil) {
                texture = isEnabled ? defaultTexture : disabledTexture
            }
        }
    }
    var isSelected: Bool = false {
        didSet {
            //texture = isSelected ? selectedTexture : defaultTexture
            
            if (isSelected) {
                colorBlendFactor = 0.5
            } else {
                colorBlendFactor = 0.0
            }
        }
    }
    var defaultTexture: SKTexture
    var selectedTexture: SKTexture
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(normalTexture defaultTexture: SKTexture!, selectedTexture:SKTexture!, disabledTexture: SKTexture?) {
        
        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.disabledTexture = disabledTexture
        
        super.init(texture: defaultTexture, color: UIColor.blackColor(), size: defaultTexture.size())
        
        userInteractionEnabled = true
        
        // Adding this node as an empty layer. Without it the touch functions are not being called
        // The reason for this is unknown when this was implemented...?
        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: defaultTexture.size())
        bugFixLayerNode.position = self.position
        addChild(bugFixLayerNode)
        
    }

    
    var disabledTexture: SKTexture?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent!)  {
        
        if (!isEnabled) {
            return
        }
        isSelected = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent!)  {
        
        if (!isEnabled) {
            return
        }
        
        let touch = touches.first
        let touchLocation = touch!.locationInNode(parent!)
        
        if (CGRectContainsPoint(frame, touchLocation)) {
            isSelected = true
        } else {
            isSelected = false
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent!) {
        
        if (!isEnabled) {
            return
        }
        
        isSelected = false
        
        let touch = touches.first
        let touchLocation = touch!.locationInNode(parent!)
            
        if (CGRectContainsPoint(frame, touchLocation) ) {
            // toggle whose turn it is
            let gameScene = scene as! GameScene
            gameScene.currentTurn = gameScene.currentTurn?.otherPlayer
        }
        
    }
    
}