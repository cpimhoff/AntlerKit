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

extension RespondsToContact {
	
	func onContact(with other: GameObject?, phase: PhysicsContactPhase) {
		switch phase {
		case .begin:
			self.onContactBegan(with: other)
		case .end:
			self.onContactEnded(with: other)
		}
	}
	
}
