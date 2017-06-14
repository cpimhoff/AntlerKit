//
//  Scene.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

open class Scene {
	
	// MARK: - Static
	
	/// The currently rendered scene
	public static var current : Scene! {
		return Scene.stack.head
	}
	
	/// This application's scene stack
	internal static var stack = SceneStack()
	
	// MARK: - Top Level Objects
	
	private var topLevelGameObjects = [GameObject]()
	
	// MARK: - Initialization
	
	internal var root : WrappedScene
	
	internal init(root: WrappedScene, preprocessing: ((Scene)->())? = nil) {
		self.root = root
		initializeRoot()
		preprocessing?(self)
		self.setup()
	}
	
	private func initializeRoot() {
		self.root.delegateScene = self
		self.root.physicsWorld.contactDelegate = self.root
		
		self.ambientLightSource.categoryBitMask = ~0	// apply to all categories
		self.root.addChild(self.ambientLightSource)
	}
	
	public convenience init(size: Size) {
		self.init(root: WrappedScene(size: size))
	}
	
	// MARK: - Properties
	
	open var stateMachine : StateMachine?
	
	open var camera : Camera? {
		didSet {
			self.root.camera = self.camera?.cameraNode
		}
	}
	
	private var ambientLightSource = SKLightNode()
	
	// MARK: - Adding Content
	
	public func add(_ child: GameObject) {
		if child.root.scene != nil {
			return
		}
		
		self.topLevelGameObjects.append(child)	// append GameObject to root set for update
		self.root.addChild(child.root)			// append the base primitive to render
	}
	
	public func remove(_ child: GameObject) {
		child.removeFromParent()	// will call `removeFromTopLevelList` if appropriate
	}
	
	internal func removeFromTopLevelList(_ child: GameObject) {
		if let i = self.topLevelGameObjects.index(where: { $0 === child }) {
			self.topLevelGameObjects.remove(at: i)
		}
	}
	
	// MARK: - Updating Scene Content
	
	internal func _update(deltaTime: TimeInterval) {
		// update elements
		self.stateMachine?.update(deltaTime: deltaTime)
		for gameObject in topLevelGameObjects {
			gameObject._update(deltaTime: deltaTime)
		}
		
		// user handler
		self.update(deltaTime: deltaTime)
		
		// actors had a chance to update based on input, tick the input
		Input.updateStaleInput()
	}
	
	// MARK: - Override Points
	
	open func setup() {}
	open func onEnter() {}
	open func willExit() {}
	open func update(deltaTime: TimeInterval) {}
	
}

// MARK: - Exposing Key Properties
public extension Scene {
	
	var size : Size {
		return self.root.size
	}
	
	var backgroundColor : Color {
		get {
			return self.root.backgroundColor
		} set {
			self.root.backgroundColor = newValue
		}
	}
	
	var ambientColor : Color {
		get {
			return self.ambientLightSource.ambientColor
		}
		set {
			self.ambientLightSource.ambientColor = newValue
		}
	}
	
	var physicsWorld : SKPhysicsWorld {
		return self.root.physicsWorld
	}
	
}

// MARK: - Handling Physics
internal extension Scene {
	
	func handleContact(_ contact: SKPhysicsContact, phase: PhysicsContactPhase) {
		let a = (contact.bodyA.node as? RootTransform)?.gameObject
		let b = (contact.bodyB.node as? RootTransform)?.gameObject
		
		a?._onContact(with: b, phase: phase)
		b?._onContact(with: a, phase: phase)
	}
	
}
