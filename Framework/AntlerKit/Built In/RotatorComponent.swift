//
//  RotatorComponent.swift
//  AntlerKit-iOS
//
//  Created by Charlie Imhoff on 6/13/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

/// Rotates a GameObject over time
class RotatorComponent : InspectableComponent {
	
	/// Rotation speed expressed in degrees clockwise per second
	var rotationSpeedDegrees : Float {
		get { return Convert.toDegrees(fromRadians: self.rotationSpeedRadians) }
		set { self.rotationSpeedRadians = Convert.toRadians(fromDegrees: newValue) }
	}
	/// Rotation speed expressed in radians clockwise per second
	var rotationSpeedRadians : Float = 0
	
	override func update(deltaTime: TimeInterval) {
		self.gameObject.rotation -= rotationSpeedRadians * Float(deltaTime)
	}
	
}
