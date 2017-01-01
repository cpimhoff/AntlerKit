//
//  DriftRightComponent.swift
//  Example Game
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import AntlerKit

class DriftRightComponent : SimpleComponent {
	
	override func update(deltaTime: TimeInterval) {
		let speed : Double = 5.0
		self.gameObject?.position.x += CGFloat(deltaTime * speed)
		self.gameObject?.position.y += CGFloat(deltaTime * speed)
	}
	
}
