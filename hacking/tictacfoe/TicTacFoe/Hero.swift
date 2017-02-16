//
//  Hero.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 2/12/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Hero : Character {
    
    var props: Set<HeroProp>?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: HeroType) {
        
        // Get hero info
        let data = HeroInfo.data[type]
        
        super.init(imgName: data!.image)
        
        // allow the hero to intercept touches instead of passing them through the scene
        isUserInteractionEnabled = true
        
        // update stats
        maxHealth = data!.health
        health = maxHealth
        props = data!.props
        
        zPosition = ZPosition.inPlay.rawValue
        isHidden = false
    }
    

    
}
