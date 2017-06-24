//
//  TTLGameScene.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/23/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
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


/* Coding Conventions
 
 ClassName
 
 mMemberVariable
 
 sStaticMemberVariable
 
 memberFunction
 
 localVariable
 
 Use '_' in function declaration usually, always when only 1 parameter.
 
 */




class TTLGameScene: SKScene {

}
