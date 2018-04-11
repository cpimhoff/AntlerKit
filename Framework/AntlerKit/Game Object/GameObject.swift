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

/// An game entity in the AntlerKit game scene.
open class GameObject : UpdatesEachFrame {
	
	internal let root : RootTransform
	
	/// Creates a new GameObject
	public init() {
		self.root = RootTransform()
		self.root.gameObject = self
	}
	
	// MARK: - Primitive
	
	/// The visual representation of the GameObject
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
			self.animator?.gameObject = self
			if self.primitive == nil {
				// animator requires a primitive to be present
				self.primitive = SKNode()
			}
		}
	}
	
	// MARK: - Agent
	
	// use this to check if we have an agent (without touching, and thus initializing it)
	private var isAgentInitialized = false
	
	/// An Agent for this GameObject to use for AI behavior
	public lazy var agent : Agent2D = {
		self.isAgentInitialized = true
		return GKAgent2D()
	}()
	
	// MARK: - Component
	
	private var componentMap = [String: Component]()
	
	/// All the components currently associated with this GameObject
	public var components : [Component] {
		return Array(self.componentMap.values)
	}
	internal var enabledComponents : [Component] {
		return self.componentMap.values.filter { $0.enabled }
	}
	
	/// Add a component to this GameObject
	public func add(_ component: Component) {
		if component is AnonymousComponent {
			self.add(component, key: UUID().uuidString)
		} else {
			let typeName = String(describing: type(of: component))
			if self.componentMap[typeName] != nil {
				self.add(component, key: typeName)
			} else {
				self.add(component, key: UUID().uuidString)
			}
		}
	}
	
	private func add(_ component: Component, key: String) {
		self.componentMap[key] = component
		component.gameObject = self
		component.configure()
	}
	
	/// Get a Component attached to this GameObject of the specified class
	public func component<T: Component>(type: T.Type) -> T? {
		let typeName = String(describing: type)
		return self.componentMap[typeName] as? T
	}
	
	// MARK: - Children
	
	/// Add a GameObject as a child of this one
	open func add(_ child: GameObject) {
		self.root.addChild(child.root)
	}
	
	/// All the immediate child GameObjects of this GameObject
	public var children : [GameObject] {
		var gameObjects = [GameObject]()
		for node in self.root.children {
			if let transform = node as? RootTransform {
				gameObjects.append(transform.gameObject)
			}
		}
		return gameObjects
	}
	
	// MARK: - Destruction
	
	/// Remove this GameObject from its parent, orphaning it from the scene
	open func removeFromParent() {
		if self.root.parent == self.root.scene {
			let scene = (self.root.scene as? WrappedScene)?.delegateScene
			scene?.removeFromTopLevelList(self)
		}
		
		self.root.removeFromParent()	// unhook primitive from everything
	}
	
	// MARK: - Update
	
	internal func internalUpdate(deltaTime: TimeInterval) {
		if self.isAgentInitialized {
			self.updateAgent(deltaTime: deltaTime)
		}
		
		for child in self.children {
			child.internalUpdate(deltaTime: deltaTime)
		}
		
		for component in self.enabledComponents {
			component.internalUpdate(deltaTime: deltaTime)
		}
				
		// call user provided update
		self.update(deltaTime: deltaTime)
	}
	
	// MARK: - Configuration
	
	/// If true, any contact event on this gameObject will be forwarded
	/// to the children of this game object.
	public var propogateContactsToChildren = false
	
	/// If true, this gameObject should never move positions (directly moved or indirectly moved)
	/// The object is still allowed to animate frames, but its position and bounding box can not change.
	///
	/// Used to generate object graphs
	public var isStatic = false {
		didSet {
			self.body?.isDynamic = !self.isStatic
		}
	}
	
}

// MARK: - Primitive Configuration
public extension GameObject {
	
	/// The current position, relative to parent, of the reciever
	var position : Point {
		get {
			return root.position
		}
		set {
			root.position = newValue
		}
	}
	
	/// The current position in scene space of the reciever.
	var scenePosition : Point {
		get {
			guard let wrappedScene = root.scene else {
				fatalError("GameObject has not been added to a scene and thus has no scene-relative position")
			}
			return wrappedScene.convert(self.position, from: self.root)
		}
	}
	
	/// The position of the reciver in the coordinate system of the other object
	func relativePosition(in other: GameObject) -> Point {
		return self.root.convert(self.position, to: other.root)
	}
	
	/// The current rotation, relative to parent, of the reciever
	var rotation : Float {
		get {
			return Float(self.root.zRotation)
		}
		set {
			self.root.zRotation = CGFloat(newValue)
		}
	}
	
	/// The current layer, relative to parent, of the reciever
	var layer : Int {
		get {
			return Int(root.zPosition)
		}
		set {
			root.zPosition = CGFloat(newValue)
		}
	}
	
	/// The GameObject's physics body
	var body : PhysicsBody? {
		get {
			return self.root.physicsBody
		}
		set {
			self.root.physicsBody = newValue
			self.root.physicsBody?.isDynamic = !self.isStatic
		}
	}
	
}
