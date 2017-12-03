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

/// Structure containing current global Input data
public struct Input {
	
	#if os(iOS)
	public static var touches = [Touch]()
	public static let motion = Motion()
	#endif
	
	#if os(macOS)
	public static var activeKeys = Set<KeyboardKey>()
	public static var cursor = Cursor()
	#endif
	
}

internal extension Input {
	
	/// Removes all input which we gather in batches
	/// preparing for a new batch
	static func removePreviousInputBatch() {
		#if os(iOS)
			self.touches = self.touches.filter { touch in touch.type == .tap }
		#endif
	}
	
	/// Progresses input types into their next state
	/// Called each frame
	static func updateStaleInput() {
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
		#elseif os(macOS)
			if self.cursor.mainButton == .click {
				self.cursor.mainButton = .up
			}
			if self.cursor.secondaryButton == .click {
				self.cursor.secondaryButton = .up
			}
		#endif
	}
	
}
