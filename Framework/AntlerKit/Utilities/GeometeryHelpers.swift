//
//  GeometeryHelpers.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

public extension Point {
	
	/// The absolute distance to another point in the same space
	func distance(to other:Point) -> CGFloat {
		let dx = self.x - other.x
		let dy = self.y - other.y
		
		return sqrt(dx*dx + dy*dy)
	}
	
	/// Returns a point between this and the other given point
	func midpoint(to other:Point) -> Point {
		let vect = self.vector(to: other)
		let offset = vect.scaled(0.5)
		return self.translated(by: offset)
	}
	
	/// Returns a new CGPoint, offset by the given values
	func translated(dx:CGFloat, dy:CGFloat) -> Point {
		return Point(x: self.x + dx, y: self.y + dy)
	}
	
	/// Returns a new CGPoint, offset by the given vector
	func translated(by vector:Vector) -> Point {
		return Point(x: self.x + vector.dx, y: self.y + vector.dy)
	}
	
	/// Returns a new vector, computed from the distance of two points in the same space
	func vector(to point:Point) -> Vector {
		return Vector(dx: point.x - self.x, dy: point.y - self.y)
	}
	
	/// Returns the angle (in radians) the given point rests at in terms of this point.
	/// North is considered the start of the unit circle (zero).
	func angle(to point:Point) -> CGFloat {
		return self.vector(to: point).angle
	}
	
}

public extension Vector {
	
	/// Returns a new vector scaled evenly to both axis
	func scaled(_ amount:CGFloat) -> Vector {
		return CGVector(dx: self.dx * amount, dy: self.dy * amount)
	}
	
	/// The computed length of the vector. Same as the magnitude
	var length : CGFloat {
		get {
			return sqrt(dx * dx + dy * dy)
		}
	}
	
	/// The relative magnitude of the vector, comparable to other sqrMagnitudes
	/// Easier to compute than length
	var sqrMagnitude : CGFloat {
		get {
			return dx * dx + dy * dy
		}
	}
	
	/// Returns the angle (in radians) this vector represents.
	/// North is considered the start of the unit circle (zero).
	var angle : CGFloat {
		return atan2(dy, dx) - CGFloat.pi
	}
	
	/// Returns a vector in the oppisite direction as the reciever.
	var reversed : Vector {
		return Vector(dx: -dx, dy: -dy)
	}
	
	/// Returns a vector with inverted dx and dy as the reciever.
	var inverted : Vector {
		return Vector(dx: dy, dy: dx)
	}
	
	/// Normalized version of the vector
	var normalized : Vector {
		get {
			let length = self.length
			if length != 0 {
				return Vector(dx: dx/length, dy: dy/length)
			} else {
				return Vector.zero
			}
		}
	}
	
}

