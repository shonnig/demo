//
//  TTLCard.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class TTLCard: SKSpriteNode {
    
    var mOriginalPosition: CGPoint?
    var mOriginalTouch: CGPoint?
    
    var mZoomed = false
    
    var mHighlight: SKEffectNode?
    
    var mGlowFilter: GlowFilter?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(texture: SKTexture(imageNamed: GameCard.sFrameImage), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))
        // TODO: investigate this?
        colorBlendFactor = 0.2
        
        // Highlight effect. Card node is actually a child of this effect.
        mHighlight = SKEffectNode()
        mGlowFilter = GlowFilter()
        if let highlight = mHighlight, let glowFilter = mGlowFilter {
            glowFilter.glowColor = GameCard.sHighlightColor.withAlphaComponent(0.0)
            glowFilter.inputRadius = 20
            highlight.shouldRasterize = true
            highlight.filter = glowFilter
            
            if let scene = GameScene.sCurrentScene {
                scene.addChild(highlight)
                highlight.addChild(self)
            }
        }
        
        // allow the Card to intercept touches instead of passing them through the scene
        isUserInteractionEnabled = true
    }
    
    func setZ(_ z: Int) {
        mHighlight?.zPosition = CGFloat(z)
    }
    
    func modZ(_ z: Int) {
        mHighlight?.zPosition += CGFloat(z)
    }
    
    func setHighlight(_ enabled: Bool) {
        if enabled {
            mGlowFilter?.glowColor = GameCard.sHighlightColor.withAlphaComponent(0.5)
        } else {
            mGlowFilter?.glowColor = GameCard.sHighlightColor.withAlphaComponent(0.0)
        }
    }
    
    func moveTo(_ x: Int, _ y: Int) {
        // TODO: stop animation in progress? Only for movement?
        
        let moveTo = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.6)
        moveTo.timingMode = SKActionTimingMode.easeInEaseOut;
        run(moveTo, withKey: "move")
    }
    
    func setZoom(_ enabled: Bool) {
        if enabled && !mZoomed{
            setScale(2) // TODO
            modZ(5000) // TODO
            mOriginalPosition = position
            position = CGPoint(x: position.x, y: 400) // TODO
            mZoomed = true
        } else if !enabled && mZoomed {
            setScale(1) // TODO
            modZ(-5000) // TODO
            if let origPos = mOriginalPosition {
                position = origPos
            }
            mZoomed = false
        }
    }
    
    // Zoomed in view of the card when touching it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            mOriginalTouch = touch.location(in: GameScene.sCurrentView)
        }
        setZoom(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let newTouch = touches.first?.location(in: GameScene.sCurrentView), let origTouch = mOriginalTouch {
            // End zoom if moved about X pixels from first touch
            let tolerance = CGFloat(10)
            if abs(newTouch.x - origTouch.x) > tolerance || abs(newTouch.y - origTouch.y) > tolerance {
                setZoom(false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setZoom(false)
    }
}
