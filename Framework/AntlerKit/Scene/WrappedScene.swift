//
//  WrappedScene.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

internal class WrappedScene : SKScene {
	
	weak var delegateScene : Scene!
	
	internal var gestureRecognizers = [GestureRecognizer]()
	
	var lastUpdate : TimeInterval?
	override func update(_ currentTime: TimeInterval) {
		if lastUpdate != nil {
			let delta = currentTime - lastUpdate!
			delegateScene._update(deltaTime: delta)
		}
		lastUpdate = currentTime
	}
	
	override func didMove(to view: SKView) {
		super.didMove(to: view)
		setupGestureRecognizers()
		
		delegateScene?.onEnter()
	}
	
	override func willMove(from view: SKView) {
		super.willMove(from: view)
		removeGestureRecognizers()
		
		delegateScene?.willExit()
	}
	
}

extension WrappedScene : SKPhysicsContactDelegate {
	
	func didBegin(_ contact: SKPhysicsContact) {
		delegateScene.handleContact(contact, phase: .begin)
	}
	
	func didEnd(_ contact: SKPhysicsContact) {
		delegateScene.handleContact(contact, phase: .end)
	}
	
}
