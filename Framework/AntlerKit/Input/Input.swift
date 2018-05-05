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
	public static var touches = [UITouch]()
	public static var taps = [TouchTap]()
	public static let motion = Motion()
	#endif
	
	#if os(macOS)
	public static var activeKeys = Set<KeyboardKey>()
	public static var cursor = Cursor()
	#endif
	
}

internal extension Input {
	
	/// Progresses input types into their next state
	/// Called each frame
	static func updateStaleInput() {
		#if os(iOS)
		// Note the "touch loop" happens on the same thread as the SpriteKit update loop.
		self.touches = self.touches.filter {
			return ![.ended, .cancelled].contains($0.phase)
		}
		// Taps should be removed as they only persist for a single frame.
		self.taps.removeAll()
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
