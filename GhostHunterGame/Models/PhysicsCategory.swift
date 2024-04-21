//
//  PhysicsCategory.swift
//  GhostHunterGame
//
//  Created by Mykhailo Tseitlin on 21.04.2024.
//

import Foundation

struct PhysicsCategory {
    
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let monster: UInt32 = 0b1
    static let projectile: UInt32 = 0b10
    
}
