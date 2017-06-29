//
//  GamePhase.swift
//  TicTacFoe
//
//  Created by Scott Honnigford on 6/28/17.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Foundation

class GamePhase {
    
    func enter() {
        // Do nothing in base phase
    }
    
    func update() {
        // Do nothing in base phase
    }
}


class GamePhaseInit: GamePhase {
    
    override func update() {
        
        // TODO: Main menu? Or booting before that?
        
        GameScene.setPhase(GamePhaseCardPlay())
    }
}

class GamePhaseCardPlay: GamePhase {
    
    override func enter() {
        
        GameScene.getPlayer().updateValidChoices()
    }
    
    override func update() {
        
        
    }
}
