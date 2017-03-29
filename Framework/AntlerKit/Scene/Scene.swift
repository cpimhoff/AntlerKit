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
	internal static var stack = SceneStack()
	
	// MARK: - Top Level Objects
	
	private var topLevelGameObjects = [GameObject]()
	
	// MARK: - Wrap a SKScene for rendering
	
	internal var root : WrappedScene
	
	public init(size: Size) {
		self.root = WrappedScene(size: size)
		
		initializeRoot()
		
		self.setup()
	}
	
	public init?(fileNamed fileName: String) {
		guard let scene = WrappedScene(fileNamed: fileName) else { return nil }
		self.root = scene
		
		initializeRoot()
		
		// TODO: postprocess scene into GameObjects, Components...
		
		self.setup()
	}
	
	private func initializeRoot() {
		self.root.delegateScene = self
		self.root.physicsWorld.contactDelegate = self.root
		
		self.ambientLightSource.categoryBitMask = ~(.allZeros)	// apply to all categories
		self.root.addChild(self.ambientLightSource)
	}
	
	// MARK: - Properties
	
	open var camera : Camera? {
		didSet {
			self.root.camera = self.camera?.cameraNode
		}
	}
	
	private var ambientLightSource = SKLightNode()
	open var ambientColor : Color {
		get {
			return self.ambientLightSource.ambientColor
		}
		set {
			self.ambientLightSource.ambientColor = newValue
		}
	}
	
	// MARK: - Adding Content
	
	open func add(_ child: GameObject) {
		if child.root.scene != nil {
			return
		}
		
		self.topLevelGameObjects.append(child)	// append GameObject to root set for update
		self.root.addChild(child.root)			// append the base primitive to render
	}
	
	open func remove(_ child: GameObject) {
		child.removeFromParent()	// will call `removeFromTopLevelList` if appropriate
	}
	
	internal func removeFromTopLevelList(_ child: GameObject) {
		for i in 0..<self.topLevelGameObjects.count {
			if self.topLevelGameObjects[i] === child {
				self.topLevelGameObjects.remove(at: i)
				break
			}
		}
	}
	
	// MARK: - Updating Scene Content
	
	internal func _update(deltaTime: TimeInterval) {
		for gameObject in topLevelGameObjects {
			gameObject._update(deltaTime: deltaTime)
		}
		self.update(deltaTime: deltaTime)
		
		// actors had a chance to update based on input, tick the input
		Input.global.updateStaleInput()
	}
	
	// MARK: - Override Points
	
	open func setup() {}
	open func update(deltaTime: TimeInterval) {}
	
}

// MARK: - Exposing Key Properties
public extension Scene {
	
	public var size : Size {
		return self.root.size
	}
	
	public var backgroundColor : Color {
		get {
			return self.root.backgroundColor
		} set {
			self.root.backgroundColor = newValue
		}
	}
	
}

// MARK: - Handling Physics
internal extension Scene {
	
	internal func handleContact(_ contact: SKPhysicsContact, phase: PhysicsContactPhase) {
		let a = (contact.bodyA.node as? RootTransform)?.gameObject
		let b = (contact.bodyB.node as? RootTransform)?.gameObject
		
		a?._onContact(with: b, phase: phase)
		b?._onContact(with: a, phase: phase)
	}
	
}
