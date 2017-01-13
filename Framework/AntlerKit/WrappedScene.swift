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

#if os(iOS)
typealias GestureRecognizer = UIGestureRecognizer
#elseif os(macOS)
typealias GestureRecognizer = NSGestureRecognizer
#endif

internal class WrappedScene : SKScene {
	
	weak var delegateScene : Scene!
	
	var gestureRecognizers = [GestureRecognizer]()
	
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
	}
	
	override func willMove(from view: SKView) {
		super.willMove(from: view)
		removeGestureRecognizers()
	}
	
}

extension WrappedScene : SKPhysicsContactDelegate {
	
	func didBegin(_ contact: SKPhysicsContact) {
		delegateScene.handleContact(contact, type: .begin)
	}
	
	func didEnd(_ contact: SKPhysicsContact) {
		delegateScene.handleContact(contact, type: .end)
	}
	
}

#if os(iOS)
	extension WrappedScene {
		
		fileprivate func setupGestureRecognizers() {
			let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
			tapRecognizer.delaysTouchesBegan = true
			tapRecognizer.cancelsTouchesInView = false
			self.view?.addGestureRecognizer(tapRecognizer)
		}
		
		fileprivate func removeGestureRecognizers() {
			for gr in self.gestureRecognizers {
				self.view?.removeGestureRecognizer(gr)
			}
		}
		
		func onTap(sender: UITapGestureRecognizer) {
			guard let view = self.view, sender.state == .ended
				else { return }
			
			for i in 0..<sender.numberOfTouches {
				let viewLocation = sender.location(ofTouch: i, in: view)
				let sceneLocation = self.convertPoint(fromView: viewLocation)
				
				// Give selected nodes interested in this first option to handle it
				let selectedNodes = self.nodes(at: sceneLocation)
				let sortedGameObjects = selectedNodes
					.filter { n in		n is RootTransform }
					.map 	{ rt in		(rt as! RootTransform).gameObject }
					.sorted { a, b in	a.layer > b.layer }
				
				for gameObject in sortedGameObjects {
					if gameObject.handleSelected() {
						return
					}
				}
				
				// If unhandled, dispatch to global input
				let tap = Touch(sceneLocation: sceneLocation, type: .tap)
				Input.global.touches.append(tap)
			}
		}
		
		///
		///		Our goal is to have a complete list of the touches at all times
		///		Whenever a touch update occurs, we flash `all` active touches to memory
		///
		
		override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			handleAllRawTouches(event: event)
		}
		override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
			handleAllRawTouches(event: event)
		}
		override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
			handleAllRawTouches(event: event)
		}
		override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
			handleAllRawTouches(event: event)
		}
		
		func handleAllRawTouches(event: UIEvent?) {
			guard let touches = event?.allTouches
				else { return }
			
			// update with new info
			Input.global.removeCachedInput()
			
			for rawTouch in touches {
				if rawTouch.view != self.view { continue }
				
				let sceneLocation = rawTouch.location(in: self)
				let touch = Touch(sceneLocation: sceneLocation, type: TouchType(phase: rawTouch.phase))
				Input.global.touches.append(touch)
			}
		}
		
	}
#elseif os(macOS)
	extension WrappedScene {

		override func mouseUp(with event: NSEvent) {

		}

		override func mouseDown(with event: NSEvent) {

		}

		override func mouseMoved(with event: NSEvent) {

		}

		override func mouseDragged(with event: NSEvent) {

		}
		
	}
#endif
