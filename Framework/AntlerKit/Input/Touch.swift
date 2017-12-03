//
//  Touch.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import UIKit

/// Information about a touch event
public struct Touch {
	
	/// The location in the scene that this touch was on
	public var sceneLocation : Point
	
	/// The state of the touch
	public var type : TouchType
	
}

/// The state (or phase) of a given touch event
public enum TouchType {
	
	/// The touch began on previous frame
	case began
	/// The touch has remained but not changed since the previous frame
	case stationary
	/// The touch has moved since the previous frame
	case moved
	/// The touch ended between the previous frame and this one
	case ended
	/// The touch was cancelled between the previous frame and this one
	case cancelled
	
	/// The touch event was fired by a "tap" gesture
	/// A tap event is only active for a single frame
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
