//
//  Input.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

#if os(iOS)
	import UIKit
#elseif os(macOS)
	import AppKit
#endif


open class Input {
	
	open static var global = Input()
	
	#if os(iOS)
	open var touches = [Touch]()
	
	// var deviceTilt...
	#endif
	
	#if os(macOS)
	open var activeKeys = Set<String>()
	
	open var cursor = Cursor()
	#endif
	
}

extension Input {
	
	/// Removes all input not related to an event (such as a tap)
	/// Called when new a input data batch comes in 
	func removeCachedInput() {
		#if os(iOS)
			self.touches = self.touches.filter { touch in touch.type == .tap }
		#endif
	}
	
	/// Progresses input types into their next state
	/// Called each frame
	internal func updateStaleInput() {
		#if os(iOS)
			let updatedTouches = self.touches.flatMap
				{ touch -> Touch? in
					var nextType : TouchType
					
					switch touch.type {
					case .began, .moved, .stationary:	// should be set to stationary after a frame
						nextType = .stationary
					case .cancelled, .ended, .tap:		// should be removed after one frame
						return nil
					}
					return Touch(sceneLocation: touch.sceneLocation, type: nextType)
				}
			
			self.touches = updatedTouches
		#endif
	}
	
}
