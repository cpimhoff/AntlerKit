//
//  GameObjectTag.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 2/4/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// GameObject tags define special additional behavior and processing on a GameObject
struct GameObjectTag : OptionSet, Hashable {
	
	var hashValue : Int {
		get {
			return rawValue.hashValue
		}
	}
	let rawValue : UInt32
	
	init(rawValue:UInt32) {
		self.rawValue = rawValue
	}
	
	/// `debug` GameObjects only appear in dev builds
	static var debug : GameObjectTag {
		return GameObjectTag(rawValue: 1<<31)
	}
	
	/// `none` no special tags
	static var none : GameObjectTag {
		return GameObjectTag(rawValue: 0)
	}
	
}
