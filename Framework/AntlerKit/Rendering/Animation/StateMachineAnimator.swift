//
//  StateMachineAnimator.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 5/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

open class StateMachineAnimator: Animator {
	
	public let stateMachine : GKStateMachine
	
	public init(sheetName: String, states: [AnimationState]) {
		self.stateMachine = GKStateMachine(states: states)
		super.init(sheetName: sheetName)
	}
	
	open override func update(deltaTime: TimeInterval) {
		self.stateMachine.update(deltaTime: deltaTime)
	}
	
}
