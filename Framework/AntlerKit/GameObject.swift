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
	
	// MARK: - Component
	
	fileprivate var components = [String: Component]()
	
	open func add(_ component: Component) {
		let typeName = String(describing: type(of: component))
		self.components[typeName] = component
	
		component.gameObject = self
		component.configure()
	}
	
	open func component<T: Component>() -> T? {
		let typeName = String(describing: T.self)
		return self.components[typeName] as? T
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
		self.root.removeFromParent()
	}
	open func destroy() {
		// just a different name
		self.removeFromParent()
	}
	
	// MARK: - Update
	
	internal func _update(deltaTime: TimeInterval) {
		for child in self.children {
			child.update(deltaTime: deltaTime)
		}
		
		for component in self.components.values {
			component.update(deltaTime: deltaTime)
		}
		
		// call override point of update
		self.update(deltaTime: deltaTime)
	}

	// MARK: - Override Points
	
	open func update(deltaTime: TimeInterval) {}
	
	open func onContact(with other: GameObject, type: PhysicsContactType) {}
	
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
	
	internal func _onContact(with other: GameObject, type: PhysicsContactType) {
		self.onContact(with: other, type: type)
		
		for component in self.components.values {
			component.onContact(with: other, type: type)
		}
		
		// TODO: Send this to children if some property is set?
	}
	
}

// MARK: - Location
public extension GameObject {
	
	public var position : Point {
		get {
			return root.position
		}
		set {
			root.position = newValue
		}
	}
	
	public var rotation : Float {
		get {
			return Float(self.root.zRotation)
		}
		set {
			self.root.zRotation = CGFloat(newValue)
		}
	}
	
	public var layer : Int {
		get {
			return Int(root.zPosition)
		}
		set {
			root.zPosition = CGFloat(newValue)
		}
	}
	
}
