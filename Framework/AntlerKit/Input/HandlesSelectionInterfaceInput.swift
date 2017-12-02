//
//  HandlesSelectionInterfaceInput.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public protocol HandlesSelectionInterfaceInput {
	
	@discardableResult
	func handleSelected() -> Bool
	
}

internal extension GameObject {
	
	// Internal propogation of selection input responses
	func _handleSelected() -> Bool {
		// send to self (if subscribed)
		var handled = (self as? HandlesSelectionInterfaceInput)?.handleSelected() ?? false
		
		// send to subscribed components
		for component in self.enabledComponents.flatMap({$0 as? HandlesSelectionInterfaceInput}) {
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

extension StateMachineComponent : HandlesSelectionInterfaceInput {
	
	public func handleSelected() -> Bool {
		if let respondingState = self.activeState as? HandlesSelectionInterfaceInput {
			return respondingState.handleSelected()
		}
		return false
	}
	
}
