//
//  RespondsToContact.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/28/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// Declare comformance on a `GameObject` or a `Component` to hook into
/// contact events related to the reciever.
public protocol RespondsToContact {
	
	func onContactBegan(with other: GameObject?)
	
	func onContactEnded(with other: GameObject?)
	
}

internal extension RespondsToContact {
	
	func onContact(with other: GameObject?, phase: PhysicsContactPhase) {
		switch phase {
		case .begin:
			self.onContactBegan(with: other)
		case .end:
			self.onContactEnded(with: other)
		}
	}
	
}

internal extension GameObject {
	
	// Internal propogation of contact responses
	func _onContact(with other: GameObject?, phase: PhysicsContactPhase) {
		// send to self (if subscribed)
		(self as? RespondsToContact)?.onContact(with: other, phase: phase)
		
		// send to subscribed components
		for component in self.enabledComponents.flatMap({$0 as? RespondsToContact}) {
			component.onContact(with: other, phase: phase)
		}
		
		// send to child if configured to do so
		if self.propogateContactsToChildren {
			for child in self.children {
				child._onContact(with: other, phase: phase)
			}
		}
	}
	
}
