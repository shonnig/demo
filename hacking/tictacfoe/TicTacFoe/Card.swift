//
//  Card.swift
//  Project11
//
//  Created by Scott Honnigford on 3/31/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation
import SpriteKit

// TODO: can Tile just include a Tile reference? Can get row and col from there and would be simpler to find Tile.
enum CardLocation {
    case Hand
    // row and col
    case Tile(Int, Int)
    case Deck
    case Discard
    case Choice
}

class Card : SKSpriteNode {
    
    var props: Set<CardProp>?
    
    var cardBack: SKSpriteNode
    
    var faceDown = false {
        didSet {
            cardBack.hidden = !faceDown
        }
    }
    
    var costLabel: SKLabelNode!
    
    var cost: Int = 1 {
        didSet {
            costLabel.text = "\(cost)"
        }
    }
    
    var attackLabel: SKLabelNode!
    
    var damage: Int = 1 {
        didSet {
            attackLabel.text = "\(damage)"
        }
    }
    
    var healthLabel: SKLabelNode!

    var maxHealth: Int = 1 {
        didSet {
            healthLabel.text = "\(health)/\(maxHealth)"
        }
    }
    
    var health: Int = 1 {
        didSet {
            healthLabel.text = "\(health)/\(maxHealth)"
        }
    }
    
    var player: Player
    
    // TODO: temp, will eventually vary by card type
    var moveInterval: CFTimeInterval = 4
    
    var attackInterval: CFTimeInterval = 2
    
    var nextMoveTime: CFTimeInterval?
    
    var nextAttackTime: CFTimeInterval?
    
    var location: CardLocation?
    
    var isPickedUp = false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(_player: Player, type: CardType) {
        
        player = _player
        
        var bgColor: UIColor
        
        if player.isPlayer {
            bgColor = UIColor.blueColor()
            
        } else {
            bgColor = UIColor.greenColor()
        }
        
        // make the card back which is only visible when the card is face down
        cardBack = SKSpriteNode(texture: SKTexture(imageNamed: "border.jpg"), color:bgColor, size: CGSize(width: 200, height: 300))
        cardBack.colorBlendFactor = 0.1
        cardBack.zPosition = ZPosition.CardBack.rawValue - ZPosition.CardInHand.rawValue
        cardBack.hidden = true
        
        super.init(texture: SKTexture(imageNamed: "enemy_card.jpg"), color:bgColor, size: CGSize(width: 200, height: 300))
        colorBlendFactor = 0.1
 
        // allow the Card to intercept touches instead of passing them through the scene
        userInteractionEnabled = true
        
        // Get card info
        let data = CardInfo.data[type]
        
        // make the character image and attach to card
        let cardImage = SKSpriteNode(imageNamed: data!.image)
        cardImage.setScale((CGFloat)(data!.scale))
        cardImage.zPosition = ZPosition.CardImage.rawValue - ZPosition.CardInHand.rawValue
        addChild(cardImage)
        
        // update stats
        cost = data!.cost
        damage = data!.attack
        maxHealth = data!.health
        health = maxHealth
        props = data!.props
        
        // Add the health label
        healthLabel = SKLabelNode(fontNamed: "Arial")
        healthLabel.text = "\(health)/\(maxHealth)"
        healthLabel.fontColor = UIColor.blackColor()
        healthLabel.zPosition = ZPosition.CardLabel.rawValue - ZPosition.CardInHand.rawValue
        healthLabel.position = CGPointMake(0,-140)
        addChild(healthLabel)

        // Add the attack label
        attackLabel = SKLabelNode(fontNamed: "Arial")
        attackLabel.text = "\(damage)"
        attackLabel.fontColor = UIColor.redColor()
        attackLabel.zPosition = ZPosition.CardLabel.rawValue - ZPosition.CardInHand.rawValue
        attackLabel.position = CGPointMake(-60,110)
        addChild(attackLabel)
        
        // Add the cost label
        costLabel = SKLabelNode(fontNamed: "Arial")
        costLabel.text = "\(cost)"
        costLabel.fontColor = UIColor.blueColor()
        costLabel.zPosition = ZPosition.CardLabel.rawValue - ZPosition.CardInHand.rawValue
        costLabel.position = CGPointMake(60,110)
        addChild(costLabel)
        
        addChild(cardBack)
        faceDown = false
        
        setScale(0.33)
    }

    func isInHand() -> Bool {
        var ret:Bool
        switch location! {
        case .Hand: ret = true
        default: ret = false
        }
        return ret
    }
    
    func isOnBoard() -> Bool {
        var ret:Bool
        switch location! {
        case .Tile: ret = true
        default: ret = false
        }
        return ret
    }
    
    
    func die() {
        
        // clear occupation if it has any
        let tile = currentTile()
        tile?.occupiedBy = nil
        
        // reset card's stats
        health = maxHealth
        nextMoveTime = nil
        nextAttackTime = nil
        
        // remove from hand if there
        if isInHand() {
            player.hand!.removeCard(self)
        }
        
        player.discard!.addCard(self)
        
        // TODO: fade away and/or go to discard pile?
        let wait = SKAction.waitForDuration(0.2)
        
        //let fade = SKAction.fadeOutWithDuration(0.5)
        //let dieFade = SKAction.sequence([wait, fade])
        //runAction(dieFade, withKey: "fade")
        
        let snapTo = SKAction.moveTo(player.discard!.position, duration: 0.5)
        let dieDiscard = SKAction.sequence([wait, snapTo])
        runAction(dieDiscard, withKey: "discard")
    }
    
    // TODO: will we ever have units that move more than one space at a time?
    func nextMoveTile() -> Tile? {
        var tile: Tile?
        
        switch location! {
        case .Tile(let row, let col):
            let gameScene = scene as! GameScene
            var rowMove = 1
            if !player.isPlayer {
                // opponent moves down
                rowMove = -1
            }
            
            // TODO: really need constants for row/col ranges
            let index = ((row + rowMove) * 5) + col
            if index >= 0 && index < gameScene.tiles.count {
                tile = gameScene.tiles[index]
            }
        default: break
        }
        
        return tile
    }
    
    func currentTile() -> Tile? {
        var tile: Tile?
        
        switch location! {
        case .Tile(let row, let col):
            let gameScene = scene as! GameScene
            let index = (row * 4) + col
            if index >= 0 && index < gameScene.tiles.count {
                tile = gameScene.tiles[index]
            }
        default: break
        }
        
        return tile
    }
    
    func startTurn() {
        if (props != nil) {
            if (props!.contains(.startTurnGainGold1)) {
                player.gold += 1
            }
        }
    }
    
    func update(currentTime: CFTimeInterval) {
        
        /*
        // See if next tile up is valid and free
        let next = nextMoveTile()
        let current = currentTile()
        
        // If we're not on a tile, don't do anything
        if current == nil {
            return
        }
        
        if next != nil {
            // Not at edge of board yet
            
            if next!.occupiedBy == nil {
                // Space is empty - reset attack timer
                nextAttackTime = nil
                
                if nextMoveTime == nil {
                    // Next space is free, we can start the timer
                    nextMoveTime = currentTime + moveInterval
                } else {
                    if nextMoveTime < currentTime {
                        // Timer expired and space is still free, we can move!
                        moveFromTileToTile(current!, toTile: next!)
                        nextMoveTime = nil
                    }
                }
            } else {
                // Space is occupied - reset move timer
                nextMoveTime = nil
                
                // Is the next space an enemy?
                if next!.occupiedBy?.player.isPlayer != player.isPlayer {
                    
                    if nextAttackTime == nil {
                        // start the timer
                        nextAttackTime = currentTime + attackInterval
                    } else {
                        if nextAttackTime < currentTime {
                            // Timer expired and there's still an enemy - attack!
                            attackFromTileToTile(current!, toTile: next!)
                            nextAttackTime = nil
                        }
                    }
                }
            }
        } else {
            // We're at the edge of the board - get ready to attack base!
            if nextAttackTime == nil {
                nextAttackTime = currentTime + attackInterval
            } else {
                if nextAttackTime < currentTime {
                    // attack!
                    attackFromTileToBase(current!)
                    nextAttackTime = nil
                }
            }
            
        }
        */
        
        // Did we die from damage this turn?
        if health <= 0 {
            die()
        }
    }
    
    func applyDamage(to: Card, damage: Int) {
        to.health -= damage
        health -= to.damage
    }
    
    /*
    func applyDamageToBase(to: Player, damage: Int) {
      to.life -= damage
    }
    */

    func attackFromTileToTile(fromTile: Tile, toTile: Tile) {
        
        // There should be something to attack
        assert(toTile.occupiedBy != nil)
        
        // damage image
        let dmgImage = SKSpriteNode(imageNamed: "Explosion.png")
        dmgImage.setScale(0.25)
        dmgImage.position = toTile.position
        dmgImage.zPosition = ZPosition.DamageEffect.rawValue
        dmgImage.hidden = true
        scene!.addChild(dmgImage)

        let wait1 = SKAction.waitForDuration(0.4)
        let showDmg = SKAction.unhide()
        let doDmg = SKAction.runBlock({self.applyDamage(toTile.occupiedBy!, damage: self.damage)})
        let wait2 = SKAction.waitForDuration(0.3)
        let fadeDmg = SKAction.fadeOutWithDuration(0.3)
        let removeDmg = SKAction.removeFromParent()
        let dmgCycle = SKAction.sequence([wait1, showDmg, doDmg, wait2, fadeDmg, removeDmg])
        dmgImage.runAction(dmgCycle, withKey: "damage")
        
        // animate attack
        // TODO: make separate function? And probably can do math directly on points?
        // find partial position to opponent
        let oppPos = toTile.occupiedBy!.position
        let xDiff = (oppPos.x - position.x) * 0.35
        let yDiff = (oppPos.y - position.y) * 0.35
        let attPos = CGPoint(x: position.x + xDiff, y: position.y + yDiff)
        
        let attackTo = SKAction.moveTo(attPos, duration: 0.2)
        let wait = SKAction.waitForDuration(0.3)
        let attackBack = SKAction.moveTo(fromTile.position, duration: 0.2)
        let cycle = SKAction.sequence([attackTo, wait, attackBack])
        runAction(cycle, withKey: "attack")
        
        // TODO: hacky way to try to give possibly overlapping cards different zPositions - not sufficient
        // more than one card attacking same tile
        //zPosition = CGFloat(20 + ((toTile.row * 5) + toTile.col) * 3)
        
        let liftUp = SKAction.scaleTo(0.75, duration: 0.2)
        let dropDown = SKAction.scaleTo(0.33, duration: 0.2)
        let upDownCycle = SKAction.sequence([liftUp, wait, dropDown])
        runAction(upDownCycle, withKey: "upDown", optionalCompletion: lowerPosition)
    }
    
    /*
    func attackFromBaseToTile(toTile: Tile) {
        
        // There should be something to attack
        assert(toTile.occupiedBy != nil)
        
        // damage image
        let dmgImage = SKSpriteNode(imageNamed: "Explosion.png")
        dmgImage.setScale(0.25)
        dmgImage.position = toTile.position
        dmgImage.zPosition = 500
        dmgImage.hidden = true
        scene!.addChild(dmgImage)
        
        let wait1 = SKAction.waitForDuration(0.2)
        let showDmg = SKAction.unhide()
        let doDmg = SKAction.runBlock({self.applyDamage(toTile.occupiedBy!, damage: self.damage)})
        let wait2 = SKAction.waitForDuration(0.3)
        let fadeDmg = SKAction.fadeOutWithDuration(0.3)
        let removeDmg = SKAction.removeFromParent()
        let dmgCycle = SKAction.sequence([wait1, showDmg, doDmg, wait2, fadeDmg, removeDmg])
        dmgImage.runAction(dmgCycle, withKey: "damage")
        
        // TODO: animate attack
    }
    
    func attackFromTileToBase(fromTile: Tile) {
        
        // There should be something to attack
        assert(fromTile.occupiedBy != nil)
        
        let attackPos = fromTile.getAdjacentBasePosition()
        
        assert(attackPos != nil)
        
        // damage image
        let dmgImage = SKSpriteNode(imageNamed: "Explosion.png")
        dmgImage.setScale(0.25)
        dmgImage.position = attackPos!
        dmgImage.zPosition = 500
        dmgImage.hidden = true
        scene!.addChild(dmgImage)
        
        let wait1 = SKAction.waitForDuration(0.2)
        let showDmg = SKAction.unhide()
        let doDmg = SKAction.runBlock({self.applyDamageToBase(self.player.otherPlayer!, damage: self.damage)})
        let wait2 = SKAction.waitForDuration(0.3)
        let fadeDmg = SKAction.fadeOutWithDuration(0.3)
        let removeDmg = SKAction.removeFromParent()
        let dmgCycle = SKAction.sequence([wait1, showDmg, doDmg, wait2, fadeDmg, removeDmg])
        dmgImage.runAction(dmgCycle, withKey: "damage")
        
        // animate attack
        // TODO: make separate function? And probably can do math directly on points?
        // find partial position to opponent
        let xDiff = (attackPos!.x - position.x) * 0.35
        let yDiff = (attackPos!.y - position.y) * 0.35
        let attPos = CGPoint(x: position.x + xDiff, y: position.y + yDiff)
        
        let attackTo = SKAction.moveTo(attPos, duration: 0.2)
        let wait = SKAction.waitForDuration(0.1)
        let attackBack = SKAction.moveTo(position, duration: 0.2)
        let cycle = SKAction.sequence([attackTo, wait, attackBack])
        runAction(cycle, withKey: "attack")
        
        // TODO: hacky way to try to give possibly overlapping cards different zPositions - not sufficient
        // more than one card attacking same tile
        zPosition = CGFloat(20 + ((fromTile.row * 5) + fromTile.col) * 3)
        
        let liftUp = SKAction.scaleTo(0.5, duration: 0.2)
        let dropDown = SKAction.scaleTo(0.33, duration: 0.2)
        let upDownCycle = SKAction.sequence([liftUp, wait, dropDown])
        runAction(upDownCycle, withKey: "upDown", optionalCompletion: lowerPosition)
    }
    */
    
    func moveFromTileToTile(fromTile: Tile, toTile: Tile) {
     
        fromTile.occupiedBy = nil
        
        location = .Tile(toTile.row, toTile.col)
        
        // This better not be occupied already
        assert(toTile.occupiedBy == nil)
        
        toTile.occupiedBy = self
        
        // animate to this
        let snapToPosition = toTile.position
        let snapTo = SKAction.moveTo(snapToPosition, duration: 0.3)
        runAction(snapTo, withKey: "snap")
        
        /*
        let liftUp = SKAction.scaleTo(0.5, duration: 0.15)
        let dropDown = SKAction.scaleTo(0.33, duration: 0.15)
        let upDownCycle = SKAction.sequence([liftUp, dropDown])
        runAction(upDownCycle, withKey: "upDown", optionalCompletion: lowerPosition)

        // Possibly need to update highlight color, so force re-add of highlight
        let hightlighted = Tile.currentHighlight
        if hightlighted != nil {
            hightlighted!.removeHighlight()
            hightlighted!.addHighlight(self)
        }
        */
    }
    
    func moveFromHandToTile(toTile: Tile) {
        
        // take out of hand
        player.hand!.removeCard(self)
        
        // set on board
        location = .Tile(toTile.row, toTile.col)

        // This better not be occupied already
        assert(toTile.occupiedBy == nil || toTile.occupiedBy == self)
        
        toTile.occupiedBy = self
        
        // animate to center on tile
        let snapToPosition = toTile.position
        let snapTo = SKAction.moveTo(snapToPosition, duration: 0.3)
        runAction(snapTo, withKey: "snap")
        
        // align hand
        player.hand!.alignHand()
        
        // pay gold cost
        player.gold -= cost
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Can only move cards from hand or on board
        if !isInHand() && !isOnBoard() {
            return
        }
        
        // Can only move cards for the current turn
        let gameScene = scene as! GameScene
        if gameScene.currentTurn!.isPlayer != player.isPlayer {
            return
        }
        
        // Can only play from hand with enough gold
        if isInHand() && cost > gameScene.currentTurn!.gold {
            return
        }
        
        zPosition = ZPosition.MovingCard.rawValue
        let liftUp = SKAction.scaleTo(0.5, duration: 0.3)
        runAction(liftUp, withKey: "pickup")
            
        startWiggle()
        isPickedUp = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Can only move cards from hand or on board
        if !isInHand() && !isOnBoard() {
            return
        }
        
        // Can only move cards for the current turn
        let gameScene = scene as! GameScene
        if gameScene.currentTurn!.isPlayer != player.isPlayer {
            return
        }
        
        // Can only play from hand with enough gold
        if isInHand() && cost > gameScene.currentTurn!.gold {
            return
        }
        
        for touch in touches {
            let location = touch.locationInNode(scene!) // make sure this is scene, not self
            let touchedNode = nodeAtPoint(location)
            touchedNode.position = location
            startWiggle()
            
            // Remove highlight, then add it back if it's still over a tile
            if Tile.currentHighlight != nil {
                Tile.currentHighlight?.removeHighlight()
            }
            
            let nodes = scene?.nodesAtPoint(location)
            for node in nodes! {
                if node is Tile {
                    let tile = node as! Tile
                    tile.addHighlight(self)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Can only move cards from hand or on board
        if !isInHand() && !isOnBoard() {
            return
        }
        
        // Can only move cards for the current turn
        let gameScene = scene as! GameScene
        if gameScene.currentTurn!.isPlayer != player.isPlayer {
            return
        }
        
        // Can only play from hand with enough gold
        if isInHand() && cost > gameScene.currentTurn!.gold {
            return
        }
        
        let dropDown = SKAction.scaleTo(0.33, duration: 0.3)
        runAction(dropDown, withKey: "drop", optionalCompletion: lowerPosition)
        stopWiggle()
        isPickedUp = false
        
        let hl = Tile.currentHighlight
        
        if (hl != nil && hl!.isValidPlay(self)) {

            if isInHand() {
                moveFromHandToTile(hl!)
            } else {
                if hl?.occupiedBy != nil && hl!.occupiedBy?.player.isPlayer != self.player.isPlayer {
                    // attacking!
                    attackFromTileToTile(currentTile()!, toTile: hl!)
                } else {
                    moveFromTileToTile(currentTile()!, toTile: hl!)
                }
            }
            
        } else {
            if (!isInHand()) {
                moveFromTileToTile(currentTile()!, toTile: currentTile()!)
            }
        }
        
        if (hl != nil) {
            hl!.removeHighlight()
        }
        
        player.hand!.alignHand()
    }
    
    func startWiggle() {
        // TODO - is it ok to check for any actions?
        if hasActions() == false {
            let startAngle = CGFloat(RandomFloat(min: 0.05, max: 0.1))
            let secondAngle = CGFloat(startAngle * -1.0)
            let time = NSTimeInterval(startAngle * 2.0)
            
            let rotBack = SKAction.rotateToAngle(0, duration: 0.15)
            let rotR = SKAction.rotateByAngle(startAngle, duration: time)
            let rotL = SKAction.rotateByAngle(secondAngle, duration: time)
            var cycle:SKAction
            
            // 50/50 left or right first
            if (RandomInt(min: 0, max: 1) == 0) {
                cycle = SKAction.sequence([rotBack, rotR, rotL])
            } else {
                cycle = SKAction.sequence([rotBack, rotL, rotR])
            }

            runAction(cycle, withKey: "wiggle")
        }
    }
    
    func stopWiggle() {
        removeActionForKey("wiggle")
        
        // return card back to normal angle
        runAction(SKAction.rotateToAngle(0, duration: 0.15), withKey:"rotate")
    }
    
    func lowerPosition() {
        zPosition = ZPosition.CardInHand.rawValue
    }

}