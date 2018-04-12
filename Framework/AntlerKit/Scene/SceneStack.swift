//
//  SceneStack.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/18/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

public extension Scene {
	
	/// Adds the scene to the top of the scene stack and transitions to it
	///
	/// - Parameters:
	///   - nextScene: The Scene to enter
	///   - transition: The transition to use between the scenes
	public func push(_ nextScene: Scene, using transition: SKTransition? = nil) {
		guard let renderer = self.root.view else { return }
		SceneStack.shared.push(nextScene, on: renderer, with: transition)
	}
	
	/// Removes this scene from the scene stack and transitions to the scene below
	///
	///	- Note: The scene stack must have a scene below this one
	/// - Parameter transition: The transition to use between the scenes
	public func pop(using transition: SKTransition? = nil) {
		guard let renderer = self.root.view else { return }
		SceneStack.shared.pop(from: renderer, with: transition)
	}
	
	/// Swaps this scene with another and transitions to it. Doesn't affect the scene stack below.
	///
	/// - Parameters:
	///   - scene: The Scene to enter
	///   - transition: The transition to use between the scenes
	public func swap(to scene: Scene, using transition: SKTransition? = nil) {
		guard let renderer = self.root.view else { return }
		SceneStack.shared.swap(to: scene, on: renderer, with: transition)
	}
	
}

internal class SceneStack {
	
	static var shared = SceneStack()
	
	private var scenes = [Scene]()
	
	var head : Scene! {
		return scenes.last
	}
	
	var height : Int {
		return scenes.count
	}
	
	func push(_ scene: Scene, on view: SKView, with transition: SKTransition? = nil) {
		scenes.append(scene)
		
		self.transition(to: scene, on: view, with: transition)
	}
	
	func pop(from view: SKView, with transition: SKTransition? = nil) {
		guard self.height > 1 else {
			fatalError("Attempted to pop a scene off the scene stack when there is only one scene remaining")
		}
		
		scenes.removeLast()
		let revealed = scenes.last!
		
		self.transition(to: revealed, on: view, with: transition)
	}
	
	func swap(to scene: Scene, on view: SKView, with transition: SKTransition? = nil) {
		scenes.removeLast()
		self.push(scene, on: view, with: transition)
	}
	
	func swapEntire(toNewBase scene: Scene, on view: SKView, with transition: SKTransition? = nil) {
		scenes.removeAll()
		self.push(scene, on: view, with: transition)
	}
	
	private func transition(to scene: Scene, on view: SKView, with transition: SKTransition?) {
		if transition != nil {
			view.presentScene(scene.root, transition: transition!)
		} else {
			view.presentScene(scene.root)
		}
	}
	
}
