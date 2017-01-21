//
//  GameScene.swift
//  Example Game
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import AntlerKit

class GameScene : Scene {
	
	var score : Float = 0
	var player : Player!
	
	override func setup() {
		self.player = Player()
		self.player.position = Point(x: 0, y: 0)
		
		self.add(player)
	}
	
	override func update(deltaTime: TimeInterval) {
	}
	
}
