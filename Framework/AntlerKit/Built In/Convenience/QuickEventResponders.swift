//
//  QuickEventResponders.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 5/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

// MARK: - Respond to Contact Quick Action

internal class RespondToContactComponent : SimpleComponent, AnonymousComponent, RespondsToContact {
	
	let phase : PhysicsContactPhase
	let action : (_ other: GameObject?) -> Void
	
	init(phase: PhysicsContactPhase, action: @escaping (_ other: GameObject?) -> Void) {
		self.phase = phase
		self.action = action
	}
	
	func onContactBegan(with other: GameObject?) {
		if phase == .begin {
			self.action(other)
		}
	}
	
	func onContactEnded(with other: GameObject?) {
		if phase == .end {
			self.action(other)
		}
	}
	
}

public extension GameObject {
	
	/// Runs the closure whenever this GameObject makes contact with another.
	public func defineOnContactsBegin(_ action: @escaping (_ other: GameObject?) -> Void) {
		let responseComponent = RespondToContactComponent(phase: .begin, action: action)
		self.add(responseComponent)
	}
	
	/// Runs the closure whenever this GameObject ends contact with another.
	public func defineOnContactsEnd(_ action: @escaping (_ other: GameObject?) -> Void) {
		let responseComponent = RespondToContactComponent(phase: .end, action: action)
		self.add(responseComponent)
	}
	
}
