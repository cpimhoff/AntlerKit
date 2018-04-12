//
//  LinearTransitionable.swift
//  AntlerKit-iOS
//
//  Created by Charlie Imhoff on 4/10/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol Interpolatable : Equatable {
	
	/// Linear interpolation between two values based on an alpha
	static func interpolate(between start: Self, and end: Self, alpha: Float) -> Self
	
}

public extension BinaryFloatingPoint {
	
	public static func interpolate(between start: Self, and end: Self, alpha: Float) -> Self {
		return start + (end - start) * Self(alpha)
	}
	
}
extension Float : Interpolatable {}
extension Double : Interpolatable {}

extension Point : Interpolatable {
	
	public static func interpolate(between start: Point, and end: Point, alpha: Float) -> Point {
		let vect = start.vector(to: end)
		let offset = vect.scaled(CGFloat(alpha))
		return start.translated(by: offset)
	}
	
}
