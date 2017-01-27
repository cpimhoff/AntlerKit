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
		let x = Float(point.x)
		let y = Float(point.y)
		
		self.init(x, y)
	}
	
}
