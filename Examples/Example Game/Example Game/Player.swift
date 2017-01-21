//
//  Player.swift
//  Example Game
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit
import AntlerKit

class Player: GameObject {
	
	override init() {
		super.init()
		
		let c = SKShapeNode(circleOfRadius: 10)
		c.fillColor = .red
		self.primitive = c
		
		let dr = DriftRightComponent()
		self.add(dr)
	}
	
	override func update(deltaTime: TimeInterval) {
		let allKeys = Input.global.activeKeys.reduce("") { (prev, nextKey) -> String in
			return prev + " " + nextKey.rawValue
		}
		
		print(allKeys)
	}
	
}
