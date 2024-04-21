//
//  CGFloat+Extension.swift
//  GhostHunterGame
//
//  Created by Mykhailo Tseitlin on 21.04.2024.
//

import Foundation

extension CGFloat {
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        CGFloat.random(in: 0..<1) * (max - min) + min
    }
    
}
