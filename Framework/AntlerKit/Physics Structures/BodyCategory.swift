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
	public init(_ categories: PhysicsBodyCategory...) {
		self.rawValue = categories.reduce(PhysicsBodyCategory.none,
			{ result, next -> PhysicsBodyCategory in
				return result.union(next)
			}).rawValue
	}
	
	 internal static var collisions	= [PhysicsBodyCategory : Set<PhysicsBodyCategory>]()
	 internal static var contacts		= [PhysicsBodyCategory : Set<PhysicsBodyCategory>]()
	
}

// MARK: - Built In Categories
public extension PhysicsBodyCategory {
	
	public static let none			= PhysicsBodyCategory(rawValue: UInt32.allZeros)
	public static let all 			= PhysicsBodyCategory(rawValue: ~UInt32.allZeros)
	
}

// MARK: - Setting Collisions and Contacts
public extension PhysicsBodyCategory {
	
	public static func enableCollision(between a: PhysicsBodyCategory, and b: PhysicsBodyCategory) {
		combineSeperatedFlags(compositeA: a, compositeB: b) { (x, y) in
			let previous = PhysicsBodyCategory.collisions[x] ?? Set<PhysicsBodyCategory>()
			let updated = previous.union([y])
			PhysicsBodyCategory.collisions[x] = updated
		}
	}
	
	public static func enableContact(between a: PhysicsBodyCategory, and b: PhysicsBodyCategory) {
		combineSeperatedFlags(compositeA: a, compositeB: b) { (x, y) in
			let previous = PhysicsBodyCategory.contacts[x] ?? Set<PhysicsBodyCategory>()
			let updated = previous.union([y])
			PhysicsBodyCategory.contacts[x] = updated
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
	
}

// MARK: - SpriteKit Integration
public extension PhysicsBody {
	
	public var category : PhysicsBodyCategory {
		get {
			return PhysicsBodyCategory(rawValue: self.categoryBitMask)
		}
		set {
			self.categoryBitMask = newValue.categoryBitMask
			self.collisionBitMask = newValue.collisionBitMask
			self.contactTestBitMask = newValue.contactTestBitMask
		}
	}
	
}

internal extension PhysicsBodyCategory {
	
	var categoryBitMask : UInt32 {
		return rawValue
	}

	var collisionBitMask : UInt32 {
		var mask = PhysicsBodyCategory.none
		
		for flag in self.seperatedFlags {
			PhysicsBodyCategory.collisions[flag]?.forEach {
				mask.insert($0)
			}
		}
		
		return mask.rawValue
	}
	
	var contactTestBitMask : UInt32 {
		var mask = PhysicsBodyCategory.none
		
		for flag in self.seperatedFlags {
			PhysicsBodyCategory.contacts[flag]?.forEach {
				mask.insert($0)
			}
		}
		
		return mask.rawValue
	}
	
}

// MARK: - Decomposing Flags
fileprivate extension PhysicsBodyCategory {
	
	fileprivate var seperatedFlags : Set<PhysicsBodyCategory> {
		var flags = Set<PhysicsBodyCategory>()
		
		for i : UInt32 in 0..<32 {
			let mask = PhysicsBodyCategory(rawValue: 1 << i)
			if self.contains(mask) {
				flags.insert(mask)
			}
		}
		
		return flags
	}
	
}
