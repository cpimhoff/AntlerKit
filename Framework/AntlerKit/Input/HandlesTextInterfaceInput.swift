//
//  HandlesTextInterfaceInput.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// Adopt this protocol on a GameObject, Component, or StateMachineState
/// to subscribe to relevent text interface input events
public protocol HandlesTextInterfaceInput {
	
	/// Respond to a text input sent to the reciever
	///
	/// - Returns: Whether or not this event was handled.
	/// 	If false, the event is propogated to the next relevant subscriber, until it is handled.
	@discardableResult
	func handle(textInput text: String) -> Bool
	
}

public extension HandlesTextInterfaceInput {
	
	/// Cause all text input to be sent to the reciver as interface input
	/// instead of being delivered to global input (or another text input subscriber)
	func makeTextResponder() {
		_HandlesTextInterfaceInput.currentResponder = self
	}
	
	/// Cause all text input to be sent to global input again
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

extension StateMachineComponent : HandlesTextInterfaceInput {
	
	public func handle(textInput text: String) -> Bool {
		if let respondingState = self.activeState as? HandlesTextInterfaceInput {
			return respondingState.handle(textInput: text)
		}
		return false
	}
	
}
