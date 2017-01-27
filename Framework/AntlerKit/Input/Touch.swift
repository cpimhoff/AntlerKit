//
//  Touch.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import UIKit

public struct Touch {
	
	public var sceneLocation : Point
	
	public var type : TouchType
	
}


public enum TouchType {
	
	case began, stationary, moved, ended, cancelled
	case tap
	
	
	internal init(phase: UITouchPhase) {
		switch phase {
		case .began:
			self = .began
		case .moved:
			self = .moved
		case .stationary:
			self = .stationary
		case .ended:
			self = .ended
		case .cancelled:
			self = .cancelled
		}
	}
	
}
