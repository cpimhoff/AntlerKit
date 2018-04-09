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
open class RotatorComponent : InspectableComponent {
	
	/// Rotation speed expressed in degrees clockwise per second
	open var rotationSpeedDegrees : Float {
		get { return Convert.toDegrees(fromRadians: self.rotationSpeedRadians) }
		set { self.rotationSpeedRadians = Convert.toRadians(fromDegrees: newValue) }
	}
	/// Rotation speed expressed in radians clockwise per second
	open var rotationSpeedRadians : Float = 0
	
	open override func update(deltaTime: TimeInterval) {
		self.gameObject.rotation -= rotationSpeedRadians * Float(deltaTime)
	}
	
}
