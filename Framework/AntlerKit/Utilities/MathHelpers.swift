//
//  MathHelpers.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreGraphics

public extension FloatingPoint {
	
	/// The value of the reciever in terms of degrees.
	/// The reciever is assumed to currently represent radians.
	public var toDegrees : Self {
		return self * (180/Self.pi)
	}
	
	/// The value of the reciever in terms of radians.
	/// The reciever is assumed to currently represent degrees.
	public var toRadians : Self {
		return self * (Self.pi/180)
	}
	
}
