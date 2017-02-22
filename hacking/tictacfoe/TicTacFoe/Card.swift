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
    case hand
    // row and col
    case tile(Int, Int)
    case deck
    case discard
    case choice
}

class Card : SKSpriteNode {
    
    // TODO: make static?
    let width = 300
    let height = 300
    
    var props: [CardProp]
    
    var title: SKLabelNode
    
    var desc: [SKLabelNode]
    
    var cost: CoinChain?
    
    var rally: CoinChain?
    
    /*
    var costLabel: SKLabelNode!
    
    var cost: Int = 1 {
        didSet {
            updateCostLabel()
        }
    }
    
    var statsLabel: SKLabelNode!
    
    var damage: Int = 1 {
        didSet {
            if spell {
                statsLabel.text = "\(damage)"
            } else {
                statsLabel.text = "\(damage)/\(health)"
            }
        }
    }

    var maxHealth: Int = 1 {
        didSet {
            if spell {
                statsLabel.text = "\(damage)"
            } else {
                statsLabel.text = "\(damage)/\(health)"
            }
            
            if health < maxHealth {
                statsLabel.fontColor = UIColor.red
            } else {
                statsLabel.fontColor = UIColor.black
            }
        }
    }
    
    var health: Int = 1 {
        didSet {
            if spell {
                statsLabel.text = "\(damage)"
            } else {
                statsLabel.text = "\(damage)/\(health)"
            }
            
            if health <= 0 {
                //die()
            }
            if health < maxHealth {
                statsLabel.fontColor = UIColor.red
            } else {
                statsLabel.fontColor = UIColor.black
            }
        }
    }
    
    var actions: Int = 0 {
        didSet {
            if isOnBoard() {
                if actions >= 1 {
                    addHighlight()
                } else {
                    removeHighlight()
                }
            }
        }
    }
    */
    
    var location: CardLocation?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(type: CardId) {
        
        // Get card info
        let data = CardInfo.data[type]
        
        props = data!.props!
        
        let font = "ArialRoundedMTBold"
        
        // Add the title label
        title = SKLabelNode(fontNamed: font)
        title.text = data?.name
        
        desc = []
        
        super.init(texture: SKTexture(imageNamed: "enemy_card.jpg"), color: UIColor.white, size: CGSize(width: width, height: height))
        // TODO: ?
        colorBlendFactor = 0.2
 
        // TODO: don't hardcode positions
        title.fontColor = UIColor.black
        title.fontSize = 50
        title.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        title.position = CGPoint(x: 0, y: 100)
        addChild(title)
        
        
        // Add the description label(s)
        if let descriptions = data!.text {
            var y_pos = -60 + (descriptions.count * 30)
            for line in descriptions {
                let label = SKLabelNode(fontNamed: font)
                label.text = line
                desc.append(label)
                label.fontColor = UIColor.black
                label.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
                label.position = CGPoint(x: 0, y: y_pos)
                addChild(label)
                y_pos -= 30
            }
        }
        
        cost = CoinChain(orange: 2,blue: 2,green: 2,purple: 2)
        cost?.zPosition = ZPosition.cardLabel.rawValue - ZPosition.inPlay.rawValue
        cost?.position = CGPoint(x: 0, y: 70)
        addChild(cost!)
        
        // allow the Card to intercept touches instead of passing them through the scene
        isUserInteractionEnabled = true
        
        /*
        
        // Add the health label
        statsLabel = SKLabelNode(fontNamed: font)
        
        if spell {
            statsLabel.text = "\(damage)"
        } else {
            statsLabel.text = "\(damage)/\(health)"
        }
        statsLabel.fontColor = UIColor.black
        statsLabel.zPosition = ZPosition.cardLabel.rawValue - ZPosition.cardInHand.rawValue
        statsLabel.position = CGPoint(x: 60,y: -140)
        addChild(statsLabel)
        
        // Add the cost label
        costLabel = SKLabelNode(fontNamed: font)
        costLabel.text = "\(cost)"
        costLabel.fontColor = UIColor.yellow
        costLabel.zPosition = ZPosition.cardLabel.rawValue - ZPosition.cardInHand.rawValue
        costLabel.position = CGPoint(x: -60,y: -140)
        addChild(costLabel)
        */
        setScale(0.33)
    }
    
    /*
    func initHighlight() {
        // create a copy of our original node to create the glow effect
        glowNode = SKSpriteNode(color: UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5), size: CGSize(width: width, height: height))
        glowNode!.setScale(1.1)
        // Make the effect go just under this tile (but above others)
        glowNode!.zPosition = ZPosition.cardInHandHighlight.rawValue - ZPosition.cardInHand.rawValue
        glowNode!.isHidden = true
        self.addChild(glowNode!)
    }
    
    func updateCostLabel() {
        costLabel.text = "\(currentCost())"
        
        if currentCost() < cost {
            costLabel.fontColor = UIColor.green
        } else {
            costLabel.fontColor = UIColor.yellow
        }
    }

    func isInHand() -> Bool {
        var ret:Bool
        switch location! {
        case .hand: ret = true
        default: ret = false
        }
        return ret
    }
    
    func isOnBoard() -> Bool {
        var ret:Bool
        switch location! {
        case .tile: ret = true
        default: ret = false
        }
        return ret
    }
    
    func isInDiscard() -> Bool {
        var ret:Bool
        switch location! {
        case .discard: ret = true
        default: ret = false
        }
        return ret
    }
    
    func die() {
        
        // clear occupation if it has any
        if let tile = currentTile() {
            tile.occupiedBy = nil
        }
        
        removeHighlight()
        
        // reset card's stats
        // TODO: reset all stats
        if !spell {
            health = maxHealth
        }
        
        // remove from hand if there
        if isInHand() {
            player.hand!.removeCard(self)
        }
        
        player.discard!.addCard(self)
        
        let wait = SKAction.wait(forDuration: 0.2)
        let snapTo = SKAction.move(to: player.discard!.position, duration: 0.5)
        let dieDiscard = SKAction.sequence([wait, snapTo])
        run(dieDiscard, withKey: "discard")
    }
    
    func getTile(_ row: Int, col: Int) -> Tile? {
        var tile: Tile?
        
        let gameScene = scene as! GameScene
        let index = (row * Tile.maxColumns) + col
        if index >= 0 && index < gameScene.tiles.count {
            tile = gameScene.tiles[index]
        }
        
        return tile
    }
    
    // TODO: Should we just point to current tile?
    func currentTile() -> Tile? {
        var tile: Tile?
        
        // FIXNOW
        switch location! {
        case .tile(let row, let col):
            tile = getTile(row, col: col)
        default: break
        }
        
        return tile
    }
    
    func currentCost() -> Int {
        return cost
    }
    */
    
    func hasProp(type: CardPropType) -> Bool {
        
        for p in props {
            if p.type == type {
                return true
            }
        }
        
        return false
    }
    
    /*
    func endTurn() {
        actions = 0
    }
    
    func startTurn() {
        
        // Reset number of actions
        actions = maxActions
        
        if hasProp(.startTurnGainGold1) {
            player.gold += 1
        }
    }
    
    func applyDamage(_ to: Card, damage: Int) {
        
        to.health -= damage
        
        // Ranged attackers and spells don't take damage
        if range == 0 && !spell {
            health -= to.damage
        }
    }

    func attackFromTileToTile(_ fromTile: Tile, toTile: Tile) {
        
        actions = actions - 1
        
        // There should be something to attack
        assert(toTile.occupiedBy != nil)
        
        // calculate damage
        let attackedUnit = toTile.occupiedBy!
        var dmg = self.damage
        if attackedUnit.hasProp(.reduceRangeDamage1) && self.range > 0 {
            dmg = max(0, dmg - 1)
        }
        
        // damage image
        let dmgImage = SKSpriteNode(imageNamed: "Explosion.png")
        dmgImage.setScale(0.25)
        dmgImage.position = toTile.position
        dmgImage.zPosition = ZPosition.damageEffect.rawValue
        dmgImage.isHidden = true
        scene!.addChild(dmgImage)

        let wait1 = SKAction.wait(forDuration: 0.4)
        let showDmg = SKAction.unhide()
        
        let doDmg = SKAction.run({self.applyDamage(attackedUnit, damage: dmg)})
        let wait2 = SKAction.wait(forDuration: 0.3)
        let fadeDmg = SKAction.fadeOut(withDuration: 0.3)
        let removeDmg = SKAction.removeFromParent()
        let dmgCycle = SKAction.sequence([wait1, showDmg, doDmg, wait2, fadeDmg, removeDmg])
        dmgImage.run(dmgCycle, withKey: "damage")
        
        // animate attack
        // TODO: make separate function? And probably can do math directly on points?
        // find partial position to opponent
        let oppPos = toTile.occupiedBy!.position
        let xDiff = (oppPos.x - position.x) * 0.35
        let yDiff = (oppPos.y - position.y) * 0.35
        let attPos = CGPoint(x: position.x + xDiff, y: position.y + yDiff)
        
        let attackTo = SKAction.move(to: attPos, duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.3)
        let attackBack = SKAction.move(to: fromTile.position, duration: 0.2)
        let cycle = SKAction.sequence([attackTo, wait, attackBack])
        run(cycle, withKey: "attack")
        
        let liftUp = SKAction.scale(to: 0.75, duration: 0.2)
        let dropDown = SKAction.scale(to: 0.33, duration: 0.2)
        let upDownCycle = SKAction.sequence([liftUp, wait, dropDown])
        //runAction(upDownCycle, withKey: "upDown", optionalCompletion: lowerPosition)
        // FIXNOW
        run(upDownCycle, withKey: "upDown")
    }
    
    func moveFromTileToTile(_ fromTile: Tile, toTile: Tile) {
     
        if fromTile != toTile {
            actions -= 1
        }
        
        fromTile.occupiedBy = nil
        
        location = .tile(toTile.row, toTile.col)
        
        // This better not be occupied already
        assert(toTile.occupiedBy == nil)
        
        toTile.occupiedBy = self
        
        // moving to a tile gives you ownership of it
        toTile.owner = player
        
        // trailblazers can claim tile in between a 2 space move
        if hasProp(.trailblazer2) {
            let rowOffset = abs(toTile.row - fromTile.row)
            let colOffset = abs(toTile.col - fromTile.col)
            var middleTile: Tile?
            
            if rowOffset == 2 {
                let middleRow = (toTile.row + fromTile.row) / 2
                middleTile = getTile(middleRow, col: toTile.col)
            }
            if colOffset == 2 {
                let middleCol = (toTile.col + fromTile.col) / 2
                middleTile = getTile(toTile.row, col: middleCol)
            }
            
            if middleTile != nil {
                middleTile!.owner = player
            }
        }
        
        // animate to this
        let snapToPosition = toTile.position
        let snapTo = SKAction.move(to: snapToPosition, duration: 0.3)
        run(snapTo, withKey: "snap")
    }
    
    // TODO: commonize this with unit attacks as well?
    func damageTile(_ toTile: Tile) {
        // damage image
        let dmgImage = SKSpriteNode(imageNamed: "Explosion.png")
        dmgImage.setScale(0.25)
        dmgImage.position = toTile.position
        dmgImage.zPosition = ZPosition.damageEffect.rawValue
        dmgImage.isHidden = true
        scene!.addChild(dmgImage)
        
        let wait1 = SKAction.wait(forDuration: 0.4)
        let showDmg = SKAction.unhide()
        let doDmg = SKAction.run({self.applyDamage(toTile.occupiedBy!, damage: self.damage)})
        let wait2 = SKAction.wait(forDuration: 0.3)
        let fadeDmg = SKAction.fadeOut(withDuration: 0.3)
        let removeDmg = SKAction.removeFromParent()
        let dmgCycle = SKAction.sequence([wait1, showDmg, doDmg, wait2, fadeDmg, removeDmg])
        dmgImage.run(dmgCycle, withKey: "damage")
    }
    
    func playSpellOnTile(_ toTile: Tile) {
        // take out of hand
        player.hand!.removeCard(self)
        
        if hasProp(.massHeal2) {
            let gameScene = scene as! GameScene
            
            // heal all player's units on board by 2
            for tile in gameScene.tiles {
                let unit = tile.occupiedBy
                if unit != nil && unit!.player.isPlayer == player.isPlayer {
                    unit!.health = min(unit!.maxHealth, unit!.health + 2)
                }
            }
        }
        
        if hasProp(.unitDamageSpell) {
            // There should be something to attack
            assert(toTile.occupiedBy != nil)
            damageTile(toTile)
        }
        
        if hasProp(.areaDamageSpell) {
            // look for any of the tiles in the area that have units and damage them
            let startRow = max(0, toTile.row - 1)
            let startCol = max(0, toTile.col - 1)
            let endRow = min(Tile.maxRows - 1, toTile.row + 1)
            let endCol = min(Tile.maxColumns - 1, toTile.col + 1)
            for row in startRow...endRow {
                for col in startCol...endCol {
                    let tile = getTile(row, col: col)
                    if tile != nil && tile!.occupiedBy != nil {
                        damageTile(tile!)
                    }
                }
            }
        }
        
        // TODO: don't do for spells like mass heal/buffs/etc (do something different)
        // animate attack
        // TODO: make separate function? And probably can do math directly on points?
        // find partial position to opponent
        let oppPos = toTile.position //toTile.occupiedBy!.position
        let xDiff = (oppPos.x - position.x) * 0.35
        let yDiff = (oppPos.y - position.y) * 0.35
        let attPos = CGPoint(x: position.x + xDiff, y: position.y + yDiff)
        
        let attackTo = SKAction.move(to: attPos, duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.3)
        // Spell should always "die" and go to discard
        let doDiscard = SKAction.run({self.die()})
        let cycle = SKAction.sequence([attackTo, wait, doDiscard])
        run(cycle, withKey: "attack")
        
        let liftUp = SKAction.scale(to: 0.75, duration: 0.2)
        let dropDown = SKAction.scale(to: 0.33, duration: 0.2)
        let upDownCycle = SKAction.sequence([liftUp, wait, dropDown])
        //runAction(upDownCycle, withKey: "upDown", optionalCompletion: lowerPosition)
        // FIXNOW
        run(upDownCycle, withKey: "upDown")
        
        // pay gold cost
        player.gold -= currentCost()
    }
    
    func moveFromHandToTile(_ toTile: Tile) {
        
        // take out of hand
        player.hand!.removeCard(self)
        
        // set on board
        location = .tile(toTile.row, toTile.col)
        
        // This _must_ get set after location for highlight to work correctly
        // TODO: unless the card has haste?
        actions = 0

        // This better not be occupied already
        assert(toTile.occupiedBy == nil || toTile.occupiedBy == self)
        
        toTile.occupiedBy = self
        
        // animate to center on tile
        let snapToPosition = toTile.position
        let snapTo = SKAction.move(to: snapToPosition, duration: 0.3)
        run(snapTo, withKey: "snap")
        
        // align hand
        player.hand!.alignHand()
        
        // pay gold cost
        player.gold -= currentCost()
        
        // apply this turn properties
        if hasProp(.thisTurnDiscount1) {
            player.goldDiscount += 1
        }
    }
    
    func canPlay() -> Bool {
        /*
        // Can only move cards from hand or on board
        if !isInHand() && !isOnBoard() {
            return false
        }
        
        // Can only move cards for the current turn
        let gameScene = scene as! GameScene
        if gameScene.currentTurn!.isPlayer != player.isPlayer {
            return false
        }
        
        // Can only play from hand with enough gold
        if isInHand() && currentCost() > gameScene.currentTurn!.gold {
            return false
        }
        
        // Can only play from board if there are actions remaining
        if isOnBoard() && actions <= 0 {
            return false
        }
        */
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !canPlay() {
            return
        }
        
        zPosition = ZPosition.movingCard.rawValue
        let liftUp = SKAction.scale(to: 0.5, duration: 0.3)
        run(liftUp, withKey: "pickup")

        startWiggle()
        isPickedUp = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !canPlay() {
            return
        }
        
        for touch in touches {
            let location = touch.location(in: scene!) // make sure this is scene, not self
            let touchedNode = atPoint(location)
            touchedNode.position = location
            startWiggle()
            
            // Remove highlight, then add it back if it's still over a tile
            if Tile.currentHighlight != nil {
                Tile.currentHighlight?.removeHighlight()
            }
            
            /*
            let nodes = scene?.nodes(at: location)
            for node in nodes! {
                if node is Tile {
                    let tile = node as! Tile
                    tile.addHighlight(self)
                }
            }
            */
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !canPlay() {
            return
        }
        
        let dropDown = SKAction.scale(to: 0.33, duration: 0.3)
        //runAction(dropDown, withKey: "drop", optionalCompletion: lowerPosition)
        run(dropDown, withKey: "drop")
        stopWiggle()
        isPickedUp = false
        
        let hl = Tile.currentHighlight
        
        if (hl != nil && hl!.isValidPlay(self)) {

            if isInHand() {
                
                // I guess spells or units can draw cards...
                if hasProp(.drawCard) {
                    player.deck!.drawCard()
                }
                
                if spell {
                    playSpellOnTile(hl!)
                } else {
                    moveFromHandToTile(hl!)
                }
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
            let time = TimeInterval(startAngle * 2.0)
            
            let rotBack = SKAction.rotate(toAngle: 0, duration: 0.15)
            let rotR = SKAction.rotate(byAngle: startAngle, duration: time)
            let rotL = SKAction.rotate(byAngle: secondAngle, duration: time)
            var cycle:SKAction
            
            // 50/50 left or right first
            if (RandomInt(min: 0, max: 1) == 0) {
                cycle = SKAction.sequence([rotBack, rotR, rotL])
            } else {
                cycle = SKAction.sequence([rotBack, rotL, rotR])
            }

            run(cycle, withKey: "wiggle")
        }
    }
    
    func stopWiggle() {
        removeAction(forKey: "wiggle")
        
        // return card back to normal angle
        run(SKAction.rotate(toAngle: 0, duration: 0.15), withKey:"rotate")
    }
    
    func lowerPosition() {
        if !isInDiscard() {
            zPosition = ZPosition.cardInHand.rawValue
        }
    }
 */

}
