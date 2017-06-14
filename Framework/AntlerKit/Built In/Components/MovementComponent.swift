//
//  MovementComponent.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/28/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

open class MovementComponent: InspectableComponent {
	
	// The speed at which to move in a vector with magnitude 1
	@GKInspectable open var baseSpeed : Float = 150
	
	/// Whether to move the GameObject via the physics simualtion
	/// or via setting its location each frame
	@GKInspectable open var usePhysicsBasedMovement : Bool = true
	
	/// Whether or not to snap the GameObject to point toward its movement vector
	@GKInspectable open var pointTowardMovement : Bool = false
	
	/// The current vector that this component is moving along or should move along.
	/// This vector's magnitude is accounted for in the speed of movement.
	open var vector : CGVector = CGVector(dx: 0, dy: 0)
	
	open override func update(deltaTime: TimeInterval) {
		self.move(deltaTime: deltaTime)
	}
	
	private func move(deltaTime: TimeInterval) {
		if self.usePhysicsBasedMovement {
			self.physicsMove(self.vector, deltaTime: deltaTime)
		} else {
			self.directMove(self.vector, deltaTime: deltaTime)
		}
		
		if pointTowardMovement {
			self.gameObject.rotation = Float(vector.angle)
		}
	}
	
	private func physicsMove(_ movement: Vector, deltaTime: TimeInterval) {
		guard let body = self.gameObject.body else { return }
		
		let cgSpeed = CGFloat(baseSpeed)
		let force = Vector(dx: movement.dx * cgSpeed,
		                   dy: movement.dy * cgSpeed)
		
		body.applyForce(force)
	}
	
	private func directMove(_ movement: Vector, deltaTime: TimeInterval) {
		let cgSpeed = CGFloat(baseSpeed)
		let cgTime = CGFloat(deltaTime)
		let offset = Vector(dx: movement.dx * cgSpeed * cgTime,
		                    dy: movement.dy * cgSpeed * cgTime)
		
		let newPos = self.gameObject.position.translated(by: offset)
		self.gameObject.position = newPos
	}
	
}
