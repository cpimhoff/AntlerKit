//
//  Animator.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/23/17.
//

import Foundation
import SpriteKit

open class Animator {
	
	open internal(set) weak var gameObject : GameObject?
	
	public let sheet : AnimationSheet
	
	public init(sheetNamed sheetName: String) {
		self.sheet = AnimationSheet(named: sheetName)
	}
	
}

extension Animator {
	
	fileprivate var loopingAnimationKey : String {
		return "AK- Looping Animation"
	}
	
	fileprivate var singleAnimationKey : String {
		return "AK- Single Animation"
	}
	
	/// Runs the animation on the reciever's sheet, at the specified rate.
	/// When the animation ends, return to the previous animation.
	///
	/// - Parameters:
	///   - animationName: Name of the animation on the reciever's sheet to run
	///   - frameTime: Seconds between animation frames
	open func runOnce(animationNamed animationName: String, frameTime: TimeInterval = 0.2) {
		guard let primitive = self.gameObject?.primitive else { return }
		guard let animation = self.sheet.load(animationNamed: animationName) else { return }
		
		// save (and then stop) current looping animation
		let previousAnimation = primitive.action(forKey: loopingAnimationKey)
		primitive.removeAction(forKey: loopingAnimationKey)
		
		// construct one-off action
		let singleAnimation = SKAction.animate(with: animation.frames, timePerFrame: frameTime)
		let returnToPreviousAnimation = SKAction.run {
			if previousAnimation != nil {
				primitive.run(previousAnimation!, withKey: self.loopingAnimationKey)
			}
		}
		let sequence = SKAction.sequence([singleAnimation, returnToPreviousAnimation])
		
		primitive.run(sequence, withKey: self.singleAnimationKey)
	}
	
	/// Loops the animation on the reciever's sheet, at the specified rate.
	///
	/// - Parameters:
	///   - animationName: Name of the animation on the reciever's sheet to run
	///   - frameTime: Seconds between animation frames
	open func transition(toAnimationNamed animationName: String, frameTime: TimeInterval = 0.2) {
		guard let primitive = self.gameObject?.primitive else { return }
		guard let animation = self.sheet.load(animationNamed: animationName) else { return }
		
		// cancel a midflight one-off immediately (its `previousAnimation` would be out of date)
		primitive.removeAction(forKey: singleAnimationKey)
		
		// construct a looping action
		let singleAnimation = SKAction.animate(with: animation.frames, timePerFrame: frameTime)
		let loopingAnimation = SKAction.repeatForever(singleAnimation)
		
		primitive.run(loopingAnimation, withKey: loopingAnimationKey)
	}
	
}

extension Animator {
	
	/// Loads all the specified animations on the reciever's sheet to memory,
	/// accelerating access to them later.
	///
	/// - Parameter animationNames: names of animations to load
	open func cache(animationsNamed animationNames: String...) {
		for animation in animationNames {
			self.sheet.load(animationNamed: animation)
		}
	}
	
}
