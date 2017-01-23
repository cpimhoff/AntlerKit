//
//  AnimationSheet.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/23/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

public class AnimationSheet {
	
	open var name : String
	
	// cache
	private var animations = [String: Animation]()
	
	public init(named name: String) {
		self.name = name
	}
	
	@discardableResult
	open func load(animationNamed animationName: String) -> Animation? {
		if let fromCache = self.animations[animationName] {
			return fromCache
		}
		
		guard let animation = Animation(sheetName: self.name, animationName: animationName)
			else { return nil }
		
		self.animations[animationName] = animation
		return animation
	}
	
}
