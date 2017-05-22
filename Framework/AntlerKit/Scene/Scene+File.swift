//
//  Scene+File.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 5/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

internal extension Scene {
	
	func preprocessLoadedSceneFile() {
		self.preprocessGameObjects()
		self.preprocessNavigationGraphs()
	}
	
	private func preprocessGameObjects() {
		self.root.children
			.flatMap(GameObject.init(unrollingNode:))
			.forEach(self.add)
	}
	
	private func preprocessNavigationGraphs() {
		
	}
	
}

fileprivate extension GameObject {
	
	convenience init(unrollingNode node: SKNode) {
		self.init()
		
		// unlink all children
		let children = node.children
		node.removeAllChildren()
		// unroll each child and add it back to this gameObject
		children
			.flatMap(GameObject.init(unrollingNode:))
			.forEach(self.add)
		
		// pull in additional settings
		self.position = node.position		// snapped to node pos. BEFORE it is recentered on GameObject
		self.layer = Int(node.zPosition)
		self.rotation = Float(node.zRotation)
		
		self.primitive = node
		self.body = node.physicsBody
		
		// components
		if let entity = node.entity {
			for component in entity.components.flatMap({$0 as? Component}) {
				self.add(component)
			}
		}
	}
	
}
