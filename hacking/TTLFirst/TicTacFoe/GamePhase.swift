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
    }
    
    func update() {
    }
    
    func endButton() {
    }
}


class GamePhaseInit: GamePhase {
    
    override func update() {
        
        // TODO: Main menu? Or booting before that?
        
        GameScene.setPhase(GamePhaseNewTurn())
    }
}

class GamePhaseNewTurn: GamePhase {
    
    override func enter() {
        
        GameScene.getPlayer().drawUpTo(5)
        GameScene.getPlayer().updateValidChoices()
        
        GameScene.setPhase(GamePhaseCardPlay())
    }
}

class GamePhaseCardPlay: GamePhase {
    
    override func enter() {
        GameScene.getPlayer().updateValidChoices()
    }
    
    override func update() {
        
    }
    
    override func endButton() {
        GameScene.setPhase(GamePhaseEndTurn())
    }
}

class GamePhaseEndTurn: GamePhase {
    
    override func enter() {
        
        // Remove remaining mana
        GameScene.getPlayer().mMana = 0
        GameScene.getPlayer().updateValidChoices()
        
        // TODO: Just start a new turn, for now
        GameScene.setPhase(GamePhaseNewTurn())
    }
}
