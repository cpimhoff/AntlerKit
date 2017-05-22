//
//  LightingCategory.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 5/17/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

public struct LightingCategory : OptionSet, Hashable {
	
	public let rawValue : UInt32
	public var hashValue : Int {
		return rawValue.hashValue
	}
	
	public init(rawValue: UInt32) {
		self.rawValue = rawValue
	}
	
	public init(uniqueInt1Through32 index: UInt32) {
		if index == 0 || index > 32 { fatalError("LightingCategory index must be within 1...32") }
		self.init(rawValue: 1 << (index - 1))
	}
	
}

// MARK: - Built In Categories
public extension LightingCategory {
	
	static let none	= LightingCategory(rawValue: .allZeros)
	static let all 	= LightingCategory(rawValue: ~.allZeros)
	
}


// MARK: - SpriteKit Integration
public extension GameObject {
	
	var litBy : LightingCategory? {
		get {
			guard let sprite = self.primitive as? SKSpriteNode else { return nil }
			return LightingCategory(rawValue: sprite.lightingBitMask)
		}
		set {
			guard let sprite = self.primitive as? SKSpriteNode else { return }
			sprite.lightingBitMask = newValue?.rawValue ?? LightingCategory.none.rawValue
		}
	}
	
	var shadowedBy : LightingCategory? {
		get {
			guard let sprite = self.primitive as? SKSpriteNode else { return nil }
			return LightingCategory(rawValue: sprite.shadowedBitMask)
		}
		set {
			guard let sprite = self.primitive as? SKSpriteNode else { return }
			sprite.shadowedBitMask = newValue?.rawValue ?? LightingCategory.none.rawValue
		}
	}

	var castShadowsFrom : LightingCategory? {
		get {
			guard let sprite = self.primitive as? SKSpriteNode else { return nil }
			return LightingCategory(rawValue: sprite.shadowCastBitMask)
		}
		set {
			guard let sprite = self.primitive as? SKSpriteNode else { return }
			sprite.shadowCastBitMask = newValue?.rawValue ?? LightingCategory.none.rawValue
		}
	}
	
}
