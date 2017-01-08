//
//  Touch.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public struct Touch {
	
	public var sceneLocation : Point
	
	public var state : TouchState
	
}

public enum TouchState {
	
	case tap
	case heldDown
	
}
