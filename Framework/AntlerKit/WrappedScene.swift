//
//  WrappedScene.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

internal class WrappedScene: SKScene {
	
	weak var delegateScene : Scene!
	
	var lastUpdate : TimeInterval?
	override func update(_ currentTime: TimeInterval) {
		if lastUpdate != nil {
			let delta = currentTime - lastUpdate!
			delegateScene._update(deltaTime: delta)
		}
		lastUpdate = currentTime
	}
	
}
