//
//  Camera.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

open class Camera : GameObject {
	
	internal var cameraNode : SKCameraNode {
		return self.primitive as! SKCameraNode
	}
	
	override public init() {
		super.init()
		self.primitive = SKCameraNode()
	}
	
}

public extension Camera {
	
	public var zoomScale : Float {
		get {
			return Float(self.cameraNode.xScale)
		}
		set {
			self.cameraNode.xScale = CGFloat(newValue)
			self.cameraNode.yScale = CGFloat(newValue)
		}
	}
	
}

public extension Camera {
	
	public func containsInViewport(_ gameObject: GameObject) -> Bool {
		return self.cameraNode.contains(gameObject.root)
	}
	
	public func allInViewport() -> [GameObject] {
		var result = [GameObject]()
		
		let nodes = self.cameraNode.containedNodeSet()
		for node in nodes {
			guard let gameObject = (node as? RootTransform)?.gameObject
				else { continue }
			
			result.append(gameObject)
		}
		
		return result
	}
	
}
