//
//  TypeConversions.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/27/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

extension vector_float2 {
	
	init(_ point: Point) {
		self.init(Float(point.x), Float(point.y))
	}
	
	init(_ vector: Vector) {
		self.init(Float(vector.dx), Float(vector.dy))
	}
	
}

extension Point {
	
	init(_ vector: vector_float2) {
		self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
	}
	
}

extension Vector {
	
	init(_ vector: vector_float2) {
		self.init(dx: CGFloat(vector.x), dy: CGFloat(vector.y))
	}
	
	init(dx: Float, dy: Float) {
		self.init(dx: Double(dx), dy: Double(dy))
	}
	
}
