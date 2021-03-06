//
//  HandlesSelectionInterfaceInput.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// Adopt this protocol on a GameObject, Component, or StateMachineState
/// to subscribe to relevent selection interface input events
public protocol HandlesSelectionInterfaceInput {
	
	/// Respond to a selection input sent to the reciever
	///
	/// - Returns: Whether or not this event was handled.
	/// 	If false, the event is propogated to the next relevant subscriber, until it is handled.
	func handleSelected() -> Bool
	
}

internal extension GameObject {
	
	// Internal propogation of selection input responses
	func _handleSelected() -> Bool {
		// send to self (if subscribed)
		var handled = (self as? HandlesSelectionInterfaceInput)?.handleSelected() ?? false
		
		// send to subscribed components
		for component in self.enabledComponents.compactMap({$0 as? HandlesSelectionInterfaceInput}) {
			handled = component.handleSelected() || handled
		}
		
		if !handled {
			for child in self.children {
				if child._handleSelected() {
					handled = true
					break
				}
			}
		}
		
		return handled
	}
	
}

extension StateMachine : HandlesSelectionInterfaceInput {
	
	public func handleSelected() -> Bool {
		if let respondingState = self.activeState as? HandlesSelectionInterfaceInput {
			return respondingState.handleSelected()
		}
		return false
	}
	
}
