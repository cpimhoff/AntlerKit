//
//  Aliases.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/31/16.
//  Copyright © 2016 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// Geometry
public typealias Point = CGPoint
public typealias Vector = CGVector
public typealias Size = CGSize

// SpriteKit
public typealias Primitive = SKNode
public typealias PhysicsBody = SKPhysicsBody
public typealias Color = SKColor

// GameplayKit
public typealias Agent = GKAgent
public typealias Agent2D = GKAgent2D

public typealias RuleSystem = GKRuleSystem
public typealias Rule = GKRule

// Cross Platform
#if os(iOS)
	internal typealias View = UIView
	public typealias Rect = CGRect
#elseif os(macOS)
	internal typealias View = NSView
	public typealias Rect = NSRect
#endif
