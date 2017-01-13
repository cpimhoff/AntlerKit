//
//  WrappedScene+Input.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/13/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
#if os(iOS)
	import UIKit
	typealias GestureRecognizer = UIGestureRecognizer
#elseif os(macOS)
	import AppKit
	typealias GestureRecognizer = NSGestureRecognizer
#endif


extension WrappedScene {
	
	internal func setupGestureRecognizers() {
		#if os(iOS)
			
			let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelect))
			tapRecognizer.delaysTouchesBegan = true
			tapRecognizer.cancelsTouchesInView = false
			
			self.gestureRecognizers.append(tapRecognizer)
			self.view?.addGestureRecognizer(tapRecognizer)
			
		#elseif os(macOS)
			
			let clickRecognizer = NSClickGestureRecognizer(target: self, action: #selector(onSelect))
			clickRecognizer.buttonMask = 1	// primary button only
			
			self.gestureRecognizers.append(clickRecognizer)
			self.view?.addGestureRecognizer(clickRecognizer)
			
		#endif
	}
	
	internal func removeGestureRecognizers() {
		for gr in self.gestureRecognizers {
			self.view?.removeGestureRecognizer(gr)
		}
	}
	
}

extension WrappedScene {
	
	/// Called on tap or click event, find the node at the selection point
	/// and send it the interface event (before dispatching to event system)
	internal func onSelect(sender: GestureRecognizer) {
		guard let view = self.view, sender.state == .ended
			else { return }
		
		// get selected point(s)
		var sceneLocations = [Point]()
		#if os(iOS)
			for i in 0..<sender.numberOfTouches {
				let viewLocation = sender.location(ofTouch: i, in: view)
				let sceneLocation = self.convertPoint(fromView: viewLocation)
				sceneLocations.append(sceneLocation)
			}
		#elseif os(macOS)
			let viewLocation = sender.location(in: view)
			let sceneLocation = self.convertPoint(fromView: viewLocation)
			sceneLocations.append(sceneLocation)
		#endif
		
		
		for selection in sceneLocations {
			
			// Give selected nodes interested in this first option to handle it
			let selectedNodes = self.nodes(at: selection)
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
			#if os(iOS)
				let tap = Touch(sceneLocation: selection, type: .tap)
				Input.global.touches.append(tap)
			#elseif os(macOS)
				Input.global.cursor.sceneLocation = selection
				Input.global.cursor.mainButton = .click
			#endif
		}
	}
	
}


#if os(iOS)
extension WrappedScene {
	
	///
	///		Our goal is to have a complete list of the touches at all times
	///		Whenever a touch update occurs, we flash `all` active touches to memory
	///
	///		Each game frame, we evaluate each touch and tick it to the next state
	///		since we only get to flash to memory on certain events.
	///
	///			example:		.moved -> .stationary         .ended -> [removed]
	///
	///		This is a safe operation, as these touch events are synced to the `update`
	///		of the embedded SKScene.   (http://stackoverflow.com/questions/29755372)
	///
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		updateTouchesBatch(allTouches: event?.allTouches)
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		updateTouchesBatch(allTouches: event?.allTouches)
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		updateTouchesBatch(allTouches: event?.allTouches)
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		updateTouchesBatch(allTouches: event?.allTouches)
	}
	
	func updateTouchesBatch(allTouches: Set<UITouch>?) {
		guard let touches = allTouches
			else { return }
		
		// update to new batch
		Input.global.removePreviousInputBatch()
		
		// filter and save this batch
		for rawTouch in touches {
			if rawTouch.view != self.view { continue }
			
			let sceneLocation = rawTouch.location(in: self)
			let touch = Touch(sceneLocation: sceneLocation, type: TouchType(phase: rawTouch.phase))
			
			Input.global.touches.append(touch)
		}
	}
	
}
#endif

#if os(macOS)
extension WrappedScene {
	
	///
	///		Since we only event have one mouse position, and there aren't phases to a
	///		mouse's button interactions, this is much simpler to track.
	///
	
	override func mouseMoved(with event: NSEvent) {
		let location = event.location(in: self)
		Input.global.cursor.sceneLocation = location
	}
	
	override func mouseUp(with event: NSEvent) {
		Input.global.cursor.mainButton = .up
	}
	
	override func mouseDown(with event: NSEvent) {
		Input.global.cursor.mainButton = .heldDown
	}
	
	override func rightMouseUp(with event: NSEvent) {
		Input.global.cursor.secondaryButton = .up
	}
	
	override func rightMouseDown(with event: NSEvent) {
		Input.global.cursor.secondaryButton = .heldDown
	}
	
}
#endif
