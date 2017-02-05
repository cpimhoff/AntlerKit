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


// MARK: - Gesture Recognization
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

// MARK: - Selection Event
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
// MARK: - Touch Input
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
// MARK: - Mouse Input
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

#if os(macOS)
// MARK: - Keyboard Input and Events
extension WrappedScene {
	
	override func keyDown(with event: NSEvent) {
		self.bridgeKeys(event: event, toInput: Input.global, down: true)
	}
	
	override func keyUp(with event: NSEvent) {
		self.bridgeKeys(event: event, toInput: Input.global, down: false)
	}
	
	private func bridgeKeys(event: NSEvent, toInput input: Input, down: Bool) {
		let updateInputWith : (KeyboardKey) -> ()
		if down {
			updateInputWith = { k in input.activeKeys.insert(k) }
		} else {
			updateInputWith = { k in input.activeKeys.remove(k) }
		}
		
		let characters = event.characters?.components(separatedBy: "") ?? []
		
		// standard keys
		for char in characters {
			if let key = KeyboardKey(rawValue: char.lowercased()) {
				updateInputWith(key)
				continue
			}
			
			if let someCode = char.unicodeScalars.first?.value {
				switch someCode {
				case 63232:
					updateInputWith(.up)
				case 63234:
					updateInputWith(.left)
				case 63235:
					updateInputWith(.right)
				case 63233:
					updateInputWith(.down)
				
				case 13:
					updateInputWith(.return)
				case 9:
					updateInputWith(.tab)
				case 127:
					updateInputWith(.backspace)
					
				case 96:
					updateInputWith(.tilde)
				
				default:
					break
				}
			}
		}
	}
	
	override func flagsChanged(with event: NSEvent) {
		let input = Input.global
		
		bridgeModifier(event: event, .capsLock, toInput: input, .capsLock)
		bridgeModifier(event: event, .command, toInput: input, .command)
		bridgeModifier(event: event, .shift, toInput: input, .shift)
		bridgeModifier(event: event, .option, toInput: input, .option)
		bridgeModifier(event: event, .control, toInput: input, .control)
	}
	
	private func bridgeModifier(event: NSEvent, _ flag: NSEventModifierFlags, toInput input: Input, _ key: KeyboardKey) {
		if event.modifierFlags.contains(flag) {
			input.activeKeys.insert(key)
		} else {
			input.activeKeys.remove(key)
		}
	}
	
}
	
public extension AntlerKitView {
	
	override func flagsChanged(with event: NSEvent) {
		Scene.stack.head?.root.flagsChanged(with: event)
	}
	
}
#endif