//
//  MathHelpers.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol NumericType {
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
}

extension Double : NumericType { }
extension Float  : NumericType { }
extension Int    : NumericType { }
extension Int8   : NumericType { }
extension Int16  : NumericType { }
extension Int32  : NumericType { }
extension Int64  : NumericType { }
extension UInt   : NumericType { }
extension UInt8  : NumericType { }
extension UInt16 : NumericType { }
extension UInt32 : NumericType { }
extension UInt64 : NumericType { }
extension CGFloat : NumericType { }

struct Convert {
	
	///Returns the representation of the supplied radians in degrees
	static func toDegrees(fromRadians radians:CGFloat) -> CGFloat {
		return radians * CGFloat(180/M_PI)
	}
	
	///Returns the representation of the supplied degrees in radians
	static func toRadians(fromDegrees degrees:CGFloat) -> CGFloat {
		return degrees * CGFloat(M_PI/180)
	}
	
}

struct Interpolate {
	
	///Linear interpolation between two numbers based on alpha
	static func linear<T: NumericType>(from a:T, to b:T, alpha:T) -> T {
		return a + (b - a) * alpha
	}
	
	///Linear interpolation between two Floats based on a delta time and speed
	///DeltaTime is in seconds, and speed is in units per second.
	static func linear<T: NumericType>(from current:T, toward target:T, deltaTime:TimeInterval, speed:T) -> T {
		if current < target {
			return min(current + (speed * T(deltaTime)), target)
		} else {
			return max(current - (speed * T(deltaTime)), target)
		}
	}
	
	///Linear interpolation between two CGPoints based on a delta time and speed
	///DeltaTime is in seconds, and speed is in units per second.
	static func linear(from current:CGPoint, toward target:CGPoint, deltaTime:CFTimeInterval, speed:CGFloat) -> CGPoint {
		let difX = current.x - target.x
		let difY = current.y - target.y
		
		let difVector = CGVector(dx: difX, dy: difY)
		let travelVector = difVector.normalized
		
		let dx = -(CGFloat(deltaTime) * speed) * travelVector.dx
		let dy = -(CGFloat(deltaTime) * speed) * travelVector.dy
		
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
