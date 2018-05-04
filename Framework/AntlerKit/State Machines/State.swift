//
//  StateMachineState.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

open class State : SimpleComponent, AbstractState {
	
	internal weak var parentStateMachineComponent : StateMachine?
	
	open func didAttach(to stateMachine: StateMachine) {
		return
	}
	
	open func isValidTransition(to: AbstractState.Type) -> Bool {
		return true
	}
	
	open func didTransition(from previousState: State) {
		return
	}
	
	open func willTransition(to newState: State) {
		return
	}
	
}
