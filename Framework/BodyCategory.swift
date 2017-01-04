//
//  BodyCategory.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/3/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

public struct PhysicsBodyCategory : OptionSet, Hashable {
	
	public let rawValue : UInt32
	public var hashValue : Int {
		return rawValue.hashValue
	}
	
	public init(rawValue: UInt32) {
		self.rawValue = rawValue
	}
	
	fileprivate static var collisions	= [PhysicsBodyCategory : Set<PhysicsBodyCategory>]()
	fileprivate static var contacts		= [PhysicsBodyCategory : Set<PhysicsBodyCategory>]()
	
}

public extension PhysicsBodyCategory {
	
	/*
	public func enableCollisions(with others: PhysicsBodyCategory) {
		PhysicsBodyCategory.enableCollision(between: self, and: others)
	}
	
	public func enableContacts(with others: PhysicsBodyCategory) {
		PhysicsBodyCategory.enableContacts(between: self, and: others)
	}
	*/
	
	public static func enableCollision(between a: PhysicsBodyCategory, and b: PhysicsBodyCategory) {
		combineSeperatedFlags(compositeA: a, compositeB: b) { (x, y) in
			let previous = PhysicsBodyCategory.collisions[x] ?? Set<PhysicsBodyCategory>()
			let updated = previous.union([y])
			PhysicsBodyCategory.collisions[x] = updated
		}
	}
	
	public static func enableContacts(between a: PhysicsBodyCategory, and b: PhysicsBodyCategory) {
		combineSeperatedFlags(compositeA: a, compositeB: b) { (x, y) in
			let previous = PhysicsBodyCategory.contacts[x] ?? Set<PhysicsBodyCategory>()
			let updated = previous.union([y])
			PhysicsBodyCategory.collisions[x] = updated
		}
	}
	
	private static func combineSeperatedFlags(compositeA: PhysicsBodyCategory, compositeB: PhysicsBodyCategory, action: (PhysicsBodyCategory, PhysicsBodyCategory) -> Void) {
		
		let aFlags = compositeA.seperatedFlags
		let bFlags = compositeB.seperatedFlags
		
		for aFlag in aFlags {
			for bFlag in bFlags {
				action(aFlag, bFlag)
				action(bFlag, aFlag)
			}
		}
	}
	
	private var seperatedFlags : [PhysicsBodyCategory] {
		return [PhysicsBodyCategory]()
	}
	
}

internal extension PhysicsBodyCategory {
	
	var categoryBitMask : UInt32 {
		return rawValue
	}
//
//	var contactTestBitMask : UInt32 {
//		
//	}
//	
//	var collisionBitMask : UInt32 {
//		
//	}
	
}

public extension PhysicsBodyCategory {
	
	public static let none			= PhysicsBodyCategory(rawValue: UInt32.allZeros)
	public static let all 			= PhysicsBodyCategory(rawValue: ~UInt32.allZeros)
	
	public static let `static` 		= PhysicsBodyCategory(rawValue: 1 << 31)
	public static let enviroment	= PhysicsBodyCategory(rawValue: 1 << 30)
	public static let effect 		= PhysicsBodyCategory(rawValue: 1 << 29)
	
}
