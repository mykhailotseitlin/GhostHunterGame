//
//  GameOverScene.swift
//  GhostHunterGame
//
//  Created by Mykhailo Tseitlin on 21.04.2024.
//

import SpriteKit

final class GameOverScene: SKScene {
    
    init(size: CGSize, isWon: Bool) {
        super.init(size: size)
        
        backgroundColor = .white
        
        let message = isWon ? "You Won!" : "You Lose :("
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3),
            SKAction.run { [weak self] in
                guard let self = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
