//
//  HandlesTextInterfaceInput.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public protocol HandlesTextInterfaceInput {
	
	@discardableResult
	func handle(textInput text: String) -> Bool
	
}

public extension HandlesTextInterfaceInput {
	
	func makeTextResponder() {
		_HandlesTextInterfaceInput.currentResponder = self
	}
	
	func resignTextResponder() {
		_HandlesTextInterfaceInput.currentResponder = nil
	}
	
}

private struct _HandlesTextInterfaceInput {
	
	internal static var currentResponder : HandlesTextInterfaceInput?
	
}

internal extension GameObject {
	
	// Internal propogation of text input responses
	func _handle(textInput text: String) -> Bool {
		// send to self (if subscribed)
		var handled = (self as? HandlesTextInterfaceInput)?.handle(textInput: text) ?? false
		
		// send to subscribed components
		for component in self.enabledComponents.flatMap({$0 as? HandlesTextInterfaceInput}) {
			handled = component.handle(textInput: text) || handled
		}
		
		if !handled {
			for child in self.children {
				if child._handle(textInput: text) {
					handled = true
					break
				}
			}
		}
		
		return handled
	}
	
}
