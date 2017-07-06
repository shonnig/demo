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
    
    var mValidPlay = false
    
    var mIsDragged = false
    
    var mLocation: TTLLocation?
    
    static var sInteractionLockCount = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(texture: SKTexture(imageNamed: GameCard.sFrameImage), color: UIColor.white, size: CGSize(width: GameCard.sWidth, height: GameCard.sHeight))
        
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
    
    func setLocation(_ location: TTLLocation?) {
        mLocation = location
    }
    
    func canInteract() -> Bool {
        return TTLCard.sInteractionLockCount == 0
    }
    
    func setInteract(_ enabled: Bool) {
        if enabled {
            TTLCard.sInteractionLockCount -= 1
        } else {
            TTLCard.sInteractionLockCount += 1
        }
    }
    
    func setZ(_ z: Int) {
        mHighlight?.zPosition = CGFloat(z)
    }
    
    func modZ(_ z: Int) {
        mHighlight?.zPosition += CGFloat(z)
    }
    
    func setValidPlay(_ valid: Bool) {
        mValidPlay = valid
    }
    
    func setHighlight(_ color: UIColor?) {
        if let c = color {
            mGlowFilter?.glowColor = c.withAlphaComponent(0.9)
        } else {
            mGlowFilter?.glowColor = GameCard.sHighlightColor.withAlphaComponent(0.0)
        }
    }
    
    func moveTo(_ x: Int, _ y: Int) {
        // TODO: stop animation in progress? Only for movement?
        
        let moveTo = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.3)
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
        if canInteract() {
            mOriginalTouch = touches.first?.location(in: scene!)
            setZoom(true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canInteract() {
            if let newTouch = touches.first?.location(in: scene!), let origTouch = mOriginalTouch {
                
                if !mIsDragged {
                    // End zoom if moved about X pixels from first touch
                    let tolerance = CGFloat(10)
                    if abs(newTouch.x - origTouch.x) > tolerance || abs(newTouch.y - origTouch.y) > tolerance {
                        setZoom(false)
                        mIsDragged = true
                        modZ(5000)
                    }
                }

                if mIsDragged {
                    setHighlight(nil)
                    position = newTouch
                    let nodes = scene?.nodes(at: newTouch)
                    for node in nodes! {
                        if node is TTLLocation {
                            let location = node as! TTLLocation
                            let highlight = location.isValidPlay(self)
                            setHighlight(highlight)
                            break
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setZoom(false)
        
        if mIsDragged {
            mIsDragged = false
            
            if let newTouch = touches.first?.location(in: scene!) {
                position = newTouch
                let nodes = scene?.nodes(at: newTouch)
                for node in nodes! {
                    if node is TTLLocation {
                        let location = node as! TTLLocation
                        location.play(self)
                        break
                    }
                }
            }
            
            mLocation?.revert()

            // TODO: hacky here, don't allow game specific here
            GameScene.getPlayer().updateValidChoices()
        }
    }
}
