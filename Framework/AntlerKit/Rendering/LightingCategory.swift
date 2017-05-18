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
	
	public static let none	= LightingCategory(rawValue: .allZeros)
	public static let all 	= LightingCategory(rawValue: ~.allZeros)
	
}


// MARK: - SpriteKit Integration
public extension GameObject {
	
	public var litBy : LightingCategory? {
		get {
			guard let sprite = self.primitive as? SKSpriteNode else { return nil }
			return LightingCategory(rawValue: sprite.lightingBitMask)
		}
		set {
			guard let sprite = self.primitive as? SKSpriteNode else { return }
			guard let mask = newValue else { return }
			
			sprite.lightingBitMask = mask.rawValue
		}
	}
	
//	public var shadowedBy : LightingCategory {
//		get { }
//	}
//	
//	public var castShadowsFrom : LightingCategory {
//		get { }
//	}
	
}
