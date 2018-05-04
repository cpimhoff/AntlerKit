//
//  StateMachineTests.swift
//  AntlerKitTests
//
//  Created by Charlie Imhoff on 4/11/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import XCTest
@testable import AntlerKit

class StateMachineTests: XCTestCase {
	
	class NonTerminalState : State {}
	class State1 : NonTerminalState {}
	class State2 : NonTerminalState {}
	class State3 : NonTerminalState {}
	class TerminalState : State {
		override func isValidTransition(to: AbstractState.Type) -> Bool {
			return false
		}
	}
	
	var stateMachine : StateMachine!
	var state1 : State!
	var state2 : State!
	var state3 : State!
	var terminalState : State!
	
	override func setUp() {
		self.state1 = State1()
		self.state2 = State2()
		self.state3 = State3()
		self.terminalState = TerminalState()
		self.stateMachine = StateMachine(states: [state1, state2, state3, terminalState])
	}
	
	func testStart() {
		XCTAssert(self.stateMachine.activeState === self.state1)
	}
	
	func testTransitionToConcrete() {
		let nextState = self.stateMachine.signalTransition(to: State3.self)
		
		XCTAssert(nextState === self.state3)
		XCTAssert(self.stateMachine.activeState === self.state3)
	}
	
	func testTransitionToAbstract() {
		self.stateMachine.activeState = self.state3
		let nextState = self.stateMachine.signalTransition(to: NonTerminalState.self)
		
		// should select the first state which is of the given abstract type
		XCTAssert(nextState === self.state1)
		XCTAssert(self.stateMachine.activeState === self.state1)
	}
	
	func testNoTransitionFromTerminal() {
		self.stateMachine.activeState = self.terminalState
		let nextState = self.stateMachine.signalTransition(to: State1.self)
		XCTAssertNil(nextState)
		XCTAssert(self.stateMachine.activeState === self.terminalState)
	}
	
}
