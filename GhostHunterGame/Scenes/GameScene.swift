//
//  GameScene.swift
//  GhostHunterGame
//
//  Created by Mykhailo Tseitlin on 20.04.2024.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    var monstersDestroyed = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        addChild(player)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1)
            ])
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        let projectilePhysicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectilePhysicsBody.isDynamic = true
        projectilePhysicsBody.categoryBitMask = PhysicsCategory.projectile
        projectilePhysicsBody.contactTestBitMask = PhysicsCategory.monster
        projectilePhysicsBody.collisionBitMask = PhysicsCategory.none
        projectilePhysicsBody.usesPreciseCollisionDetection = true
        projectile.physicsBody = projectilePhysicsBody
        projectile.position = player.position
        
        let offset = touchLocation - projectile.position
        
        guard offset.x > 0 else { return }
        
        addChild(projectile)
        
        let direction = offset.normalised()
        
        let shootAmount = direction * 1000
        
        let realDestination = shootAmount + projectile.position
        
        let actionMove = SKAction.move(to: realDestination, duration: 2)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    }
    
    func addMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        let monsterPhysicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monsterPhysicsBody.isDynamic = true
        monsterPhysicsBody.categoryBitMask = PhysicsCategory.monster
        monsterPhysicsBody.contactTestBitMask = PhysicsCategory.projectile
        monsterPhysicsBody.collisionBitMask = PhysicsCategory.none
        monster.physicsBody = monsterPhysicsBody
        
        let monsterHalfHeight = monster.size.height / 2
        let actualY = CGFloat.random(min: monsterHalfHeight, max: size.height - monsterHalfHeight)
        
        monster.position = CGPoint(x: size.width + monster.size.width / 2, y: actualY)
        addChild(monster)
        
        let actualDuration = CGFloat.random(min: 2, max: 4)
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width / 2, y: actualY), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, isWon: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    func projectileDidCollide(_ projectile: SKSpriteNode, with monster: SKSpriteNode) {
        projectile.removeFromParent()
        monster.removeFromParent()
        monstersDestroyed += 1
        if monstersDestroyed > 30 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, isWon: true)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let fistBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyA : contact.bodyB
        let secondBody: SKPhysicsBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ? contact.bodyB : contact.bodyA
        
        let isMonsterMask = fistBody.categoryBitMask & PhysicsCategory.monster != 0
        let isProjectileMack = secondBody.categoryBitMask & PhysicsCategory.projectile != 0
        
        guard isMonsterMask && isProjectileMack,
              let monster = fistBody.node as? SKSpriteNode,
              let projectile = secondBody.node as? SKSpriteNode else { return }
        
        projectileDidCollide(projectile, with: monster)
    }
    
}
