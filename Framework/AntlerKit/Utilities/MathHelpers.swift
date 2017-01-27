//
//  MathHelpers.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

/// Provides static methods for converting between units
struct Convert {
	
	///Returns the representation of the supplied radians in degrees
	static func toDegrees<T: FloatingPoint>(fromRadians radians:T) -> T {
		return radians * (180/T.pi)
	}
	
	///Returns the representation of the supplied degrees in radians
	static func toRadians<T: FloatingPoint>(fromDegrees degrees:T) -> T {
		return degrees * (T.pi/180)
	}
	
}

/// Provides static methods for interpolating between values
struct Interpolate {
	
	///Linear interpolation between two numbers based on alpha
	static func linear<T: FloatingPoint>(from a:T, to b:T, alpha:T) -> T {
		return a + (b - a) * alpha
	}
	
	///Linear interpolation between two Floats based on a delta time and speed
	///DeltaTime is in seconds, and speed is in units per second.
	static func linear<T: BinaryFloatingPoint>(from current:T, toward target:T, deltaTime:TimeInterval, speed:T) -> T {
		if current < target {
			return min(current + (speed * T(deltaTime)), target)
		} else {
			return max(current - (speed * T(deltaTime)), target)
		}
	}
	
	///Linear interpolation between two CGPoints based on a delta time and speed
	///DeltaTime is in seconds, and speed is in units per second.
	static func linear(from current:Point, toward target:Point, deltaTime:TimeInterval, rate:CGFloat) -> Point {
		let difX = current.x - target.x
		let difY = current.y - target.y
		
		let difVector = CGVector(dx: difX, dy: difY)
		let travelVector = difVector.normalized
		
		let dx = -(CGFloat(deltaTime) * rate) * travelVector.dx
		let dy = -(CGFloat(deltaTime) * rate) * travelVector.dy
		
		let newX : CGFloat
		let newY : CGFloat
		if current.x < target.x {
			newX = min(current.x + dx, target.x)
		} else {
			newX = max(current.x + dx, target.x)
		}
		if current.y < target.y {
			newY = min(current.y + dy, target.y)
		} else {
			newY = max(current.y + dy, target.y)
		}
		
		return CGPoint(x: newX, y: newY)
	}
	
}
