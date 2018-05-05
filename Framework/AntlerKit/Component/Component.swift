//
//  Component.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/31/16.
//  Copyright © 2016 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

/// An `AnonymousComponent` can be added to a `GameObject`, but not later accessed.
public protocol AnonymousComponent : Component {}

public protocol Component : UpdatesEachFrame {
	
	/// If false, this component is not updated, nor does it respond to events
	var enabled : Bool { get }
	
	/// The GameObject associated with this Component
	var gameObject : GameObject! { get set }
	
	/// Called when the Component is first bound to a GameObject.
	/// Override to do one-time setup between the Component and GameObject.
	func configure()

}

//
//	MARK:- Two Distinct Subclass Types
//

// Simplest Type
// pure Swift API and simple to manage
open class SimpleComponent : Component {
	
	open var enabled : Bool = true

	public weak var gameObject : GameObject!
	
	open func configure() {
		// override point...
	}
	
	public init() {
		// override point...
	}
	
	open func update(deltaTime: TimeInterval) {
		// override point...
	}
	
}

// GKComponent Type
// inherits '@GKInspectable' and scene editor integrations
open class InspectableComponent : GKComponent, Component {
	
	open var enabled : Bool = true
	
	public weak var gameObject : GameObject!
	
	open func configure() {
		// override point...
	}
	
}
