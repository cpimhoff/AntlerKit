//
//  Component.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/31/16.
//  Copyright © 2016 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

public protocol Component : AnyObject {
	
	/// If false, this component is not updated
	var enabled : Bool { get }
	
	var gameObject : GameObject? { get set }
	
	func configure()
	func update(deltaTime: TimeInterval)
	
	func onContact(with other: GameObject?, type: PhysicsContactType)
	
}

//
//	MARK:- Two Distinct Subclass Types
//

// Simplest Type
// pure Swift API and simple to manage
open class SimpleComponent : Component {
	
	open var enabled : Bool = true

	open weak var gameObject : GameObject?
	
	open func update(deltaTime: TimeInterval) {
		// override point...
	}
	open func configure() {
		// override point...
	}
	
	public init() {
		// override point...
	}
	
	public func onContact(with other: GameObject?, type: PhysicsContactType) {
		// override point...
	}
	
}

// GKComponent Type
// inherits '@GKInspectable' and scene editor integrations
open class InspectableComponent : GKComponent, Component {
	
	open var enabled : Bool = true
	
	open weak var gameObject : GameObject?
	
	open func configure() {
		// override point...
	}
	
	public func onContact(with other: GameObject?, type: PhysicsContactType) {
		// override point...
	}
	
}
