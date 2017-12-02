//
//  StateMachineState.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

open class StateMachineState : SimpleComponent {
	
	internal weak var parentStateMachineComponent : StateMachineComponent?
	
	open func isValidTransition(to: StateMachineState.Type) -> Bool {
		return false
	}
	
	open func didTransition(from previousState: StateMachineState) {
		return
	}
	
	open func willTransition(to newState: StateMachineState) {
		return
	}
	
}
