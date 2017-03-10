//
//  GameScene.swift
//  Project11
//
//  Created by Hudzilla on 15/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// Convert between position in parent and position in scene
extension SKNode {
    var positionInScene:CGPoint? {
        if let scene = scene, let parent = parent {
            return parent.convert(position, to:scene)
        } else {
            return nil
        }
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension SKTexture {
    class func flipImage(name:String,flipHoriz:Bool,flipVert:Bool)->SKTexture {
        if !flipHoriz && !flipVert {
            return SKTexture.init(imageNamed: name)
        }
        let image = UIImage(named:name)
        
        UIGraphicsBeginImageContext(image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        if !flipHoriz && flipVert {
            // Do nothing, X is flipped normally in a Core Graphics Context
            // but in landscape is inverted so this is Y
        } else
            if flipHoriz && !flipVert{
                // fix X axis but is inverted so fix Y axis
                context!.translateBy(x: 0, y: image!.size.height)
                context!.scaleBy(x: 1.0, y: -1.0)
                // flip Y but is inverted so flip X here
                context!.translateBy(x: image!.size.width, y: 0)
                context!.scaleBy(x: -1.0, y: 1.0)
            } else
                if flipHoriz && flipVert {
                    // flip Y but is inverted so flip X here
                    context!.translateBy(x: image!.size.width, y: 0)
                    context!.scaleBy(x: -1.0, y: 1.0)
        }
        
        //CGContextDrawImage(context, CGRectMake(0.0, 0.0, image!.size.width, image!.size.height), image!.cgImage)
        context?.draw(image!.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: image!.size.width, height: image!.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return SKTexture(image: newImage!)
    }
}

enum ZPosition: CGFloat {
    
    case background = -1000
    
    case tile = -100
    
    case tileHighlight = -20
    
    case highlightedTile = -10
    
    case inPlay = -5
    
    case buttonUI = 0
    
    case cardInHandHighlight = 5
    
    case cardInHand = 10
    
    case cardImage = 15
    
    case cardLabel = 20
    
    case cardBack = 30
    
    case damageEffect = 100
    
    case movingCardHighlight = 495 // TODO: don't think I need this, but leaving in for now...
    
    case movingCard = 500
    
    case hudUI = 1000
    
}

class GameScene: SKScene {
    
    var player: Player?
    var opponent: Player?
    
    var tiles = [Tile]()
    
    static let side: CGFloat = 140.0
    
    var promptLabel: SKLabelNode?
    
    var doneButton: FTButtonNode?
    
    var skipRally = false
    
    // Pick which bag the next coin comes from
    func selectBagWeighted() -> Player? {
        if let firstCount = player?.bag.getCompactCount(), let secondCount = opponent?.bag.getCompactCount() {
            let total = firstCount + secondCount
            if total > 0 {
                let roll = Int(arc4random_uniform(UInt32(total)))
                return (roll < firstCount ? player : opponent)
            }
        }
        return nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let p1 = player, let p2 = opponent {
            
            // Did one player just lose?
            if p1.lost {
                promptLabel!.text = "Right player won!"
                promptLabel?.isHidden = false
                return
            }
            
            if p2.lost {
                promptLabel!.text = "Left player won!"
                promptLabel?.isHidden = false
                return
            }
            
            // Does player need to resolve an action?
            if p1.isResolving || p2.isResolving {
                promptLabel!.text = "Choose a target"
                promptLabel?.isHidden = false
                return
            }
            
            // Does player need to select a card from hand?
            if p1.hand != nil || p2.hand != nil {
                promptLabel!.text = "Select your next action"
                promptLabel?.isHidden = false
                return
            }
            
            // Waiting on player to rally a card
            if p1.ralliesPending > 0 || p2.ralliesPending > 0 {
                
                // Did player push the button to skip doing a rally?
                if skipRally {
                    p1.ralliesPending = 0
                    p2.ralliesPending = 0
                    p1.disableActionsForRally()
                    p2.disableActionsForRally()
                    skipRally = false
                } else {
                    promptLabel!.text = "Rally An Action"
                    promptLabel?.isHidden = false
                }
                
                return
            }
            
            doneButton?.isUserInteractionEnabled = false
            doneButton?.isHidden = true
            promptLabel?.isHidden = true
            
            // Waiting for current pick to finish animating
            if p1.isPicking || p2.isPicking {
                return
            }
            
            // If there are coins, start selecting now...
            if let lucky = selectBagWeighted() {
                lucky.bag.pickRandomCoin()
            } else {
                // If no coins in bag for either player, prompt for rallying again...
                p1.ralliesPending = 1
                p2.ralliesPending = 1
                p1.enableActionsForRally()
                p2.enableActionsForRally()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        /*
        // For finding out available fonts
         
        for name in UIFont.familyNames {
            print(name)
            if let nameString = name as? String {
                print(UIFont.fontNames(forFamilyName: nameString))
            }
        }
        */
        
        // Init card info
        CardInfo.initInfo()
        HeroInfo.initInfo()
        
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = ZPosition.background.rawValue
		addChild(background)
        
        let buttonImg = SKTexture(imageNamed: "done.png")
        //doneButton = FTButtonNode(normalTexture: buttonImg, selectedTexture: buttonImg, disabledTexture: buttonImg)
        doneButton = FTButtonNode(defaultTexture: buttonImg)
        doneButton!.position = CGPoint(x: 980, y: 740)
        doneButton!.zPosition = ZPosition.buttonUI.rawValue
        doneButton!.isUserInteractionEnabled = false
        doneButton!.isHidden = true
        doneButton!.setScale(0.15)
        addChild(doneButton!)

        player = Player(scene: self, _isPlayer: true)
        opponent = Player(scene: self, _isPlayer: false)
        
        player!.otherPlayer = opponent
        opponent!.otherPlayer = player
        
        // Add label prompting action from player
        promptLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        promptLabel!.text = "Rally Two Actions"
        promptLabel!.fontSize = 30
        promptLabel!.fontColor = UIColor.yellow
        promptLabel!.zPosition = ZPosition.hudUI.rawValue
        promptLabel!.position = CGPoint(x: 500,y: 740)
        addChild(promptLabel!)
    }

}
