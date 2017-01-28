//
//  GameObjectAgentDelegate.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/27/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

internal extension GameObject {
	
	func updateAgent(deltaTime: TimeInterval) {
		syncAgentToReality()
		self.agent.update(deltaTime: deltaTime)
		mirrorAgentProposal()
	}
	
	/// Syncs the current objects actual position and physics parameters
	/// to the agent associated with this GameObject
	func syncAgentToReality() {
		agent.position = vector_float2(self.scenePosition)
		agent.rotation = self.rotation
	}
	
	/// Reads the agents desired state and updates the GameObject to match as best as possible
	func mirrorAgentProposal() {
		// for now, let's just match the desire exactly
		self.position = Point(agent.position)
		self.rotation = agent.rotation
		
		// QUESTION: should we also match agent.velocity to any physics body?
	}
	
}
