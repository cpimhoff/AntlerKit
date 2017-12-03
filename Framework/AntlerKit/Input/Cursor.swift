//
//  Cursor.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// Information about the state of the Cursor
public struct Cursor {
	
	/// The location in the scene the cursor is located
	/// or `nil` if the cursor is outside of the view bounds
	public var sceneLocation : Point? = nil
	
	/// The state of the primary mouse button
	public var mainButton : MouseButtonState = .up
	/// The state of the secondary mouse button
	public var secondaryButton : MouseButtonState? = nil
	
}

/// State of a mouse button
public enum MouseButtonState {
	
	/// The button is not pressed
	case up
	/// The button has been help down for multiple frames
	case heldDown
	
	/// The mouse button has undergone a "click" event
	/// A click is only active for a single frame
	case click
	
}
