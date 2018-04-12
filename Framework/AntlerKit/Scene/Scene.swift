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
		return SceneStack.shared.head
	}
	
	// MARK: - Top Level Objects
	
	/// The root set of objects that need per frame updates.
	/// Many objects (such as components, or nested game objects) are updated indirectly.
	private var directlyUpdatedObjects = [UpdatesEachFrame]()
	
	// MARK: - Initialization
	
	internal let root : WrappedScene
	
	/// Create a new scene of the specified size
	public init(size: Size) {
		self.root = WrappedScene(size: size)
		initializeRoot()
		self.setup()
	}
	
	/// Create a new scene by loading the contents of a file in the main bundle
	public init?(fileNamed fileName: String) {
		guard let root = WrappedScene(fileNamed: fileName) else { return nil }
		self.root = root
		self.initializeRoot()
		self.preprocessLoadedSceneFile()
		self.setup()
	}
	
	private func initializeRoot() {
		self.root.delegateScene = self
		self.root.physicsWorld.contactDelegate = self.root
		
		self.ambientLightSource.categoryBitMask = ~0	// apply to all categories
		self.root.addChild(self.ambientLightSource)
	}
	
	// MARK: - Properties
	
	/// The Camera object used to frame this scene's contents
	open var camera : Camera? {
		didSet {
			self.root.camera = self.camera?.cameraNode
		}
	}
	
	private var ambientLightSource = SKLightNode()
	
	// MARK: - Adding Content
	
	/// Add the specified GameObject to the root of this scene.
	public func add(_ child: GameObject) {
		guard child.root.scene == nil else { return }
		
		self.startDirectUpdates(child)
		self.root.addChild(child.root)  // append the base primitive to render
	}
	
	/// Adds the specified updating object to the root set for per frame updates.
	internal func startDirectUpdates(_ object: UpdatesEachFrame) {
		self.directlyUpdatedObjects.append(object)
	}
	
	/// Removes the specified updating object from the root set if needed.
	internal func stopDirectUpdates(_ object: UpdatesEachFrame) {
		if let i = self.directlyUpdatedObjects.index(where: { $0 === object }) {
			self.directlyUpdatedObjects.remove(at: i)
		}
	}
	
	// MARK: - Updating Scene Content
	
	internal func internalUpdate(deltaTime: TimeInterval) {
		// update entities
		for updatingObject in directlyUpdatedObjects {
			updatingObject.internalUpdate(deltaTime: deltaTime)
		}
		
		// user handler
		self.update(deltaTime: deltaTime)
		
		// actors had a chance to update based on input, tick the input
		Input.updateStaleInput()
	}
	
	// MARK: - Override Points
	
	/// Called at the end of Scene initialization.
	/// Override this method to populate/finalize the scene's contents.
	open func setup() {}
	
	/// Called when the Scene is made active
	open func onEnter() {}
	
	/// Called when the Scene will resign being active
	open func willExit() {}
	
	/// Called every frame. Override to do per frame updates on the scene.
	///
	/// - Parameter deltaTime: Time in seconds between the last frame and this one.
	open func update(deltaTime: TimeInterval) {}
	
}

// MARK: - Exposing Key Properties
public extension Scene {
	
	/// The size of the Scene
	var size : Size {
		return self.root.size
	}
	
	/// The color to render at the back of all other contents
	var backgroundColor : Color {
		get {
			return self.root.backgroundColor
		} set {
			self.root.backgroundColor = newValue
		}
	}
	
	/// The ambient light color for the Scene
	var ambientColor : Color {
		get {
			return self.ambientLightSource.ambientColor
		}
		set {
			self.ambientLightSource.ambientColor = newValue
		}
	}
	
	/// The physiccal world this Scene uses.
	/// Allows configuration of gravity, among other things.
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
