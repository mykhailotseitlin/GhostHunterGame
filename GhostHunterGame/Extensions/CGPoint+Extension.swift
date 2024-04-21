//
//  CGPoint+Extension.swift
//  GhostHunterGame
//
//  Created by Mykhailo Tseitlin on 21.04.2024.
//

import Foundation

extension CGPoint {
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
    
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func normalised() -> CGPoint {
        return self / length()
    }
    
}
