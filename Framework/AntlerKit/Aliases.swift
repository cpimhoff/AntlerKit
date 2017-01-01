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
public typealias Size = CGSize

// SpriteKit
public typealias Primitive = SKNode
public typealias PhysicsBody = SKPhysicsBody

// Cross Platform
#if os(iOS)
	internal typealias View = UIView
#elseif os(OSX)
	internal typealias View = NSView
#endif
