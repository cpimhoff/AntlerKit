//
//  StateMachineComponent.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public class StateMachineComponent : SimpleComponent {
	
	private var stateMap = [String: StateMachineState]()
	
	public var activeState : StateMachineState
	public var states : [StateMachineState] {
		return Array(stateMap.values)
	}
	
	public init(states: [StateMachineState]) {
		guard states.count > 0 else {
			fatalError("StateMachineComponents must have more than one state")
		}
		self.activeState = states.first!
		for state in states {
			let classKey = String(describing: type(of: state))
			self.stateMap[classKey] = state
		}
		
		super.init()
		
		for state in self.states {
			state.parentStateMachineComponent = self
		}
	}
	
	public override func configure() {
		for state in self.states {
			state.gameObject = self.gameObject
			state.configure()
		}
	}
	
	override public func update(deltaTime: TimeInterval) {
		self.activeState.update(deltaTime: deltaTime)
	}
	
	public func transition(to newState: StateMachineState.Type) -> Bool {
		if self.activeState.isValidTransition(to: newState) {
			let nextStateClassKey = String(describing: newState)
			if let nextState = self.stateMap[nextStateClassKey] {
				self.activeState.willTransition(to: nextState)
				let prevState = self.activeState
				self.activeState = nextState
				self.activeState.didTransition(from: prevState)
				return true
			}
		}
		return false
	}
	
}
