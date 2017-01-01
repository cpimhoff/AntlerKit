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
	
	// MARK: - Top Level References
	
	private var topLevelGameObjects = [GameObject]()
	
	// MARK: - Wrap a SKScene for rendering
	
	internal var root : WrappedScene
	
	public init(size: Size) {
		self.root = WrappedScene(size: size)
		self.root.delegateScene = self
		
		self.setup()
	}
	
	public init?(fileNamed fileName: String) {
		guard let scene = WrappedScene(fileNamed: fileName) else { return nil }
		self.root = scene
		self.root.delegateScene = self
		
		// postprocess scene into GameObjects, Components...
		
		self.setup()
	}
	
	// MARK: - Adding Content
	
	open func add(_ child: GameObject) {
		if child.root.scene != nil {
			return
		}
		
		self.topLevelGameObjects.append(child)	// append to root set to scene
		self.root.addChild(child.root)		// append the base primitive to render
	}
	
	// MARK: - Updating Scene Content
	
	internal func _update(deltaTime: TimeInterval) {
		for gameObject in topLevelGameObjects {
			gameObject._update(deltaTime: deltaTime)
		}
		
		self.update(deltaTime: deltaTime)
	}
	
	// MARK: - Override Points
	
	open func setup() {}
	open func update(deltaTime: TimeInterval) {}
	
}
