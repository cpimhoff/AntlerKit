//
//  MathHelpers.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol NumberType {
	static func +(lhs: Self, rhs: Self) -> Self
	static func -(lhs: Self, rhs: Self) -> Self
	static func *(lhs: Self, rhs: Self) -> Self
	static func /(lhs: Self, rhs: Self) -> Self
	static func %(lhs: Self, rhs: Self) -> Self
	
	static func >(lhs: Self, rhs: Self) -> Bool
	static func >=(lhs: Self, rhs: Self) -> Bool
	static func ==(lhs: Self, rhs: Self) -> Bool
	static func <=(lhs: Self, rhs: Self) -> Bool
	static func <(lhs: Self, rhs: Self) -> Bool
	
	init(_ v: Int)
	init(_ v: Float)
	init(_ v: Double)
	init(_ v: CGFloat)
}

extension Double : NumberType { }
extension Float  : NumberType { }
extension Int    : NumberType { }
extension Int8   : NumberType { }
extension Int16  : NumberType { }
extension Int32  : NumberType { }
extension Int64  : NumberType { }
extension UInt   : NumberType { }
extension UInt8  : NumberType { }
extension UInt16 : NumberType { }
extension UInt32 : NumberType { }
extension UInt64 : NumberType { }
extension CGFloat : NumberType { }

/// Provides static methods for converting between units
struct Convert {
	
	///Returns the representation of the supplied radians in degrees
	static func toDegrees<T: NumberType>(fromRadians radians:T) -> T {
		return radians * T(180/M_PI)
	}
	
	///Returns the representation of the supplied degrees in radians
	static func toRadians<T: NumberType>(fromDegrees degrees:T) -> T {
		return degrees * T(M_PI/180)
	}
	
}

/// Provides static methods for interpolating between values
struct Interpolate {
	
	///Linear interpolation between two numbers based on alpha
	static func linear<T: NumberType>(from a:T, to b:T, alpha:T) -> T {
		return a + (b - a) * alpha
	}
	
	///Linear interpolation between two Floats based on a delta time and speed
	///DeltaTime is in seconds, and speed is in units per second.
	static func linear<T: NumberType>(from current:T, toward target:T, deltaTime:TimeInterval, speed:T) -> T {
		if current < target {
			return generic_min(current + (speed * T(deltaTime)), target)
		} else {
			return generic_max(current - (speed * T(deltaTime)), target)
		}
	}
	
	///Linear interpolation between two CGPoints based on a delta time and speed
	///DeltaTime is in seconds, and speed is in units per second.
	static func linear(from current:Point, toward target:Point, deltaTime:TimeInterval, rate:Float) -> Point {
		let difX = current.x - target.x
		let difY = current.y - target.y
		
		let difVector = CGVector(dx: difX, dy: difY)
		let travelVector = difVector.normalized
		
		let dx = -(CGFloat(deltaTime) * CGFloat(rate)) * travelVector.dx
		let dy = -(CGFloat(deltaTime) * CGFloat(rate)) * travelVector.dy
		
		let newX : CGFloat
		let newY : CGFloat
		if current.x < target.x {
			newX = generic_min(current.x + dx, target.x)
		} else {
			newX = generic_max(current.x + dx, target.x)
		}
		if current.y < target.y {
			newY = generic_min(current.y + dy, target.y)
		} else {
			newY = generic_max(current.y + dy, target.y)
		}
		
		return CGPoint(x: newX, y: newY)
	}
	
}

fileprivate func generic_max<T: NumberType>(_ a: T, _ b: T) -> T {
	if a >= b {
		return a
	} else {
		return b
	}
}

fileprivate func generic_min<T: NumberType>(_ a: T, _ b: T) -> T {
	if a >= b {
		return b
	} else {
		return a
	}
}
