//
//  StateMachineComponent.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// Abstract protocol used to define state machine states.
/// The only built-in implementation of this protocol is `StateMachineState`.
/// This protocol allows for easy polymorphism without subclassing.
public protocol AbstractState {}

/// A `StateMachineComponent`
/// State machines are especially powerful in defining the behavior of an entity which can take multiple non-instantaneous actions, because the definition of each action is separated from the logic which determines which action to take. This also means that individual actions can be reused by other entities and other complex behaviors.
public class StateMachine : SimpleComponent {
	
	public var activeState : State
	public private(set) var states : [State]
	
	public init(states: [State]) {
		guard states.count > 0 else {
			fatalError("StateMachineComponents must have more than one state")
		}
		self.states = states
		self.activeState = states.first!
		
		super.init()
		
		for state in self.states {
			state.parentStateMachineComponent = self
			state.didAttach(to: self)
		}
	}
	
	public override func configure() {
		for state in self.states {
			state.gameObject = self.gameObject
			state.configure()
		}
	}
	
	public override func update(deltaTime: TimeInterval) {
		self.activeState.update(deltaTime: deltaTime)
	}
	
	/// Transition this state machine to a new state.
	/// The resultant state is the first state in this state machine's state list which is of the given type.
	///
	/// - Parameter newState: A type describing the new state.
	/// - Returns: The new state after transition, or nil if no transition occured.
	@discardableResult
	public func signalTransition<T : AbstractState>(to newState: T.Type) -> State? {
		if self.activeState.isValidTransition(to: newState) {
			if let nextState = self.states.first(where: {return $0 is T}) {
				self.activeState.willTransition(to: nextState)
				let prevState = self.activeState
				self.activeState = nextState
				self.activeState.didTransition(from: prevState)
				return nextState
			}
		}
		return nil
	}
	
}
