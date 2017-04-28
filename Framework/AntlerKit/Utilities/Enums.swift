//
//  Enums.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/28/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

enum Direction {
	
	case up, down, left, right
	
	var vector : Vector {
		switch self {
		case .up:
			return Vector(dx: 0, dy: 1)
		case .down:
			return Vector(dx: 0, dy: -1)
		case .left:
			return Vector(dx: -1, dy: 0)
		case .right:
			return Vector(dx: 1, dy: 0)
		}
	}
	
}
