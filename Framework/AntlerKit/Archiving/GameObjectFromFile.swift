//
//  GameObjectFromFile.swift
//  AntlerKit-iOS
//
//  Created by Charlie Imhoff on 6/13/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

private var gameObjectSceneLoadCache = [String: SKScene]()
public extension GameObject {
	
	/// Loads a SpriteKit scene file from the main bundle,
	/// and converts a single `SKNode` within to a `GameObject`
	///
	/// The scenes loaded are cached so there is no substantial performance cost to loading many
	/// different nodes in a single file, and calling this initializer many times.
	///
	/// - Parameters:
	///   - fileName: The name of the SpriteKit scene file in the main bundle
	///   - nodeName: The name of the top-level node to initialize as a `GameObject`
	convenience init?(fromFileNamed fileName: String, nodeNamed node: String) {
		guard let scene = gameObjectSceneLoadCache[fileName] ?? SKScene(fileNamed: fileName)
			else { return nil }
		gameObjectSceneLoadCache[fileName] = scene
		
		guard let node = scene.childNode(withName: node)
			else { return nil }
		
		self.init(unrollingNode: node)
	}
	
	/// Unrolls the contents of the given `SKNode` into a new `GameObject`
	internal convenience init(unrollingNode node: SKNode) {
		self.init()
		
		// unhook from previous parent, will be bound to this node
		node.removeFromParent()
		
		// unlink all children
		let children = node.children
		node.removeAllChildren()
		// unroll each child and add it back to this gameObject
		children
			.compactMap(GameObject.init(unrollingNode:))
			.forEach(self.add)
		
		// pull in additional settings
		self.position = node.position		// snapped to node pos. BEFORE it is recentered on GameObject
		self.layer = Int(node.zPosition)
		self.rotation = Float(node.zRotation)
		
		self.primitive = node
		self.body = node.physicsBody
		
		// AntlerKit components
		if let entity = node.entity {
			for component in entity.components.compactMap({$0 as? Component}) {
				self.add(component)
			}
		}
	}
	
}
