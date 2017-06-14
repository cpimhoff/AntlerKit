//
//  SceneFromFile.swift
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
		// TODO: implement
	}
	
}
