//
//  Cursor.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public struct Cursor {
	
	public var sceneLocation : Point? 				= nil
	
	public var mainButton : MouseButtonState 		= .up
	public var secondaryButton : MouseButtonState? 	= nil
	
}

public enum MouseButtonState {
	
	case up
	case heldDown
	
	case click
	
}
