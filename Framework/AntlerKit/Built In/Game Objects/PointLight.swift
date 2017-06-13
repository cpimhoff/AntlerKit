//
//  PointLight.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 3/29/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

open class PointLight : GameObject {
	
	private var lightNode : SKLightNode! {
		get {
			return self.primitive as? SKLightNode
		}
		set {
			self.primitive = newValue
		}
	}
	
	public override init() {
		super.init()
		self.primitive = SKLightNode()
	}
	
}

public extension PointLight {
	
	var category : LightingCategory {
		get {
			return LightingCategory(rawValue: self.lightNode.categoryBitMask)
		}
		set {
			self.lightNode.categoryBitMask = newValue.rawValue
		}
	}
	
	var falloff : Float {
		get {
			return Float(self.lightNode.falloff)
		}
		set {
			self.lightNode.falloff = CGFloat(newValue)
		}
	}
	
	var color : Color {
		get {
			return self.lightNode.lightColor
		}
		set {
			self.lightNode.lightColor = newValue
		}
	}
	
	var shadowColor : Color {
		get {
			return self.lightNode.shadowColor
		}
		set {
			self.lightNode.shadowColor = newValue
		}
	}
	
}
