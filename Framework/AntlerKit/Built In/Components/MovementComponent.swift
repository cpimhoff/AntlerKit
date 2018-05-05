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
	@GKInspectable open var usePhysicsBasedMovement = false
	
	/// Whether or not to snap the GameObject to point toward its movement vector
	@GKInspectable open var pointTowardMovement = false
	
	/// The current vector that this component is moving along or should move along.
	/// This vector's magnitude is accounted for in the speed of movement.
	open var vector = Vector.zero
	
	open override func update(deltaTime: TimeInterval) {
		self.move(deltaTime: deltaTime)
	}
	
	private func move(deltaTime: TimeInterval) {
		if self.usePhysicsBasedMovement {
			self.physicsMove(self.vector)
		} else {
			self.directMove(self.vector, deltaTime: deltaTime)
		}
		
		if pointTowardMovement {
			self.gameObject.rotation = Float(vector.angle)
		}
	}
	
	private func physicsMove(_ movement: Vector) {
		guard let body = self.gameObject.body else { return }
		
		let cgSpeed = CGFloat(baseSpeed)
		let force = Vector(dx: movement.dx * cgSpeed,
		                   dy: movement.dy * cgSpeed)
		
		body.applyForce(force)
		
		/*  DEBUG
		let lineStart = SKShapeNode(circleOfRadius: 1)
		lineStart.fillColor = .green
		lineStart.strokeColor = .clear
		let lineEnd = SKShapeNode(circleOfRadius: 1)
		lineEnd.fillColor = .green
		lineEnd.strokeColor = .clear
		
		lineStart.position = .zero
		lineEnd.position = Point(x: movement.scaled(3).dx, y: movement.scaled(3).dy)
		
		self.gameObject.root.addChild(lineStart)
		self.gameObject.root.addChild(lineEnd)
		
		let decay = SKAction.sequence([.wait(forDuration: 0.1), .removeFromParent()])
		lineStart.run(decay)
		lineEnd.run(decay)
		*/
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
