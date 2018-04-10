//
//  LinearTransitionable.swift
//  AntlerKit-iOS
//
//  Created by Charlie Imhoff on 4/10/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol LinearTransitionable : Equatable {
	
	static func interpolate(between start: Self, and end: Self, alpha: Float) -> Self
	
}

extension Float : LinearTransitionable {
	
	public static func interpolate(between start: Float, and end: Float, alpha: Float) -> Float {
		return Interpolate.linear(from: start, to: end, alpha: alpha)
	}
	
}

extension Point : LinearTransitionable {
	
	public static func interpolate(between start: Point, and end: Point, alpha: Float) -> Point {
		return Interpolate.linear(from: start, to: end, alpha: CGFloat(alpha))
	}
	
}
