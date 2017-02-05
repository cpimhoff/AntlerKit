//
//  GameObject.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 12/31/16.
//  Copyright © 2016 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

open class GameObject {
	
	internal let root : RootTransform
	
	public init() {
		self.root = RootTransform()
		self.root.gameObject = self
	}
	
	// MARK: - Primitive
	
	public var primitive : Primitive? {
		didSet {
			if oldValue != nil {
				self.root.removeChildren(in: [oldValue!])
			}
			if primitive != nil {
				primitive!.position = CGPoint(x: 0, y: 0)
				self.root.addChild(primitive!)
			}
		}
	}
	
	public var animator : Animator? {
		didSet {
			if self.primitive == nil {
				// animator requires a primitive to be present
				self.primitive = SKNode()
			}
		}
	}
	
	// MARK: - Agent
	
	// use this to check if we have an agent (without touching, and thus initializing it)
	private var isAgentInitialized = false
	public lazy var agent : GKAgent2D = {
		self.isAgentInitialized = true
		return GKAgent2D()
	}()
	
	// MARK: - Component
	
	fileprivate var components = [String: Component]()
	public var allComponents : LazyMapCollection<Dictionary<String, Component>, Component> {
		return self.components.values
	}
	
	open func add(_ component: Component) {
		let typeName = String(describing: type(of: component))
		self.components[typeName] = component
	
		component.gameObject = self
		component.configure()
	}
	
	open func component(type: Component.Type) -> Component? {
		let typeName = String(describing: type)
		return self.components[typeName] ?? nil
	}
	
	// MARK: - Children
	
	open func add(_ child: GameObject) {
		self.root.addChild(child.root)
	}
	
	open var children : [GameObject] {
		var gameObjects = [GameObject]()
		for node in self.root.children {
			if let transform = node as? RootTransform {
				gameObjects.append(transform.gameObject)
			}
		}
		return gameObjects
	}
	
	// MARK: - Destruction
	
	open func removeFromParent() {
		let scene = (self.root.scene as? WrappedScene)?.delegateScene
		scene?.removeFromTopLevelList(self)	// unhook self from scene (if needed)
		
		self.root.removeFromParent()	// unhook primitive from everything
	}
	
	// MARK: - Update
	
	internal func _update(deltaTime: TimeInterval) {
		if self.isAgentInitialized {
			self.updateAgent(deltaTime: deltaTime)
		}
		
		for child in self.children {
			child.update(deltaTime: deltaTime)
		}
		
		for component in self.components.values {
			if component.enabled {
				component.update(deltaTime: deltaTime)
			}
		}
		
		// call override point of update
		self.update(deltaTime: deltaTime)
	}
	
	// MARK: - Configuration
	
	/// If true, any contact event on this gameObject will be forwarded
	/// to the children of this game object.
	var propogateContactsToChildren = false
	
	var tags : GameObjectTag = .none

	// MARK: - Override Points
	
	/// Called every frame.
	///
	/// - Parameter deltaTime: The amount of time, in seconds, since the last call to `update`
	open func update(deltaTime: TimeInterval) {}
	
	/// Called when another game object has contacted with this one
	///
	/// - Parameters:
	///   - other: The game object involved in the collision, or nil if it was triggered by a primitive
	///   - phase: The phase of the contact
	open func onContact(with other: GameObject?, phase: PhysicsContactPhase) {}
	
}

// MARK: - Physics
public extension GameObject {
	
	public var body : PhysicsBody? {
		get {
			return self.root.physicsBody
		}
		set {
			self.root.physicsBody = body
		}
	}

	/// Internal call for `onContact`
	internal func _onContact(with other: GameObject?, phase: PhysicsContactPhase) {
		self.onContact(with: other, phase: phase)
		
		for component in self.components.values {
			if component.enabled {
				component.onContact(with: other, phase: phase)
			}
		}
		
		// send to child if configured to do so
		if self.propogateContactsToChildren {
			for child in self.children {
				child._onContact(with: other, phase: phase)
			}
		}
	}
	
}

// MARK: - Location
public extension GameObject {
	
	/// The current position, relative to parent, of the reciever
	public var position : Point {
		get {
			return root.position
		}
		set {
			root.position = newValue
		}
	}
	
	/// The current position in scene space of the reciever.
	public var scenePosition : Point! {
		get {
			guard let wrappedScene = root.scene else {
				fatalError("GameObject has not been added to a scene and thus has no scene-relative position")
			}
			return wrappedScene.convert(self.position, from: self.root)
		}
	}
	
	/// The current rotation, relative to parent, of the reciever
	public var rotation : Float {
		get {
			return Float(self.root.zRotation)
		}
		set {
			self.root.zRotation = CGFloat(newValue)
		}
	}
	
	/// The current layer, relative to parent, of the reciever
	public var layer : Int {
		get {
			return Int(root.zPosition)
		}
		set {
			root.zPosition = CGFloat(newValue)
		}
	}
	
}
