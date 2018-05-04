//
//  Animator.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/23/17.
//

import Foundation
import SpriteKit

/// An `Animator` is a special object which can be attached to a `GameObject.animator`
/// property to enable frame based animation.
open class Animator {
	
	internal weak var gameObject : GameObject?
	
	public let sheetName : String
	
	/// cache for animations
	private var animations = [String: Animation]()
	
	public init(sheetName: String) {
		self.sheetName = sheetName
	}
	
	convenience public init(sheetName: String, cacheImmediately: [String]? = nil) {
		self.init(sheetName: sheetName)
		
		if cacheImmediately != nil {
			self.cache(animationsNamed: cacheImmediately!)
		}
	}
	
}

// MARK: - Running animations
extension Animator {
	
	private var loopingAnimationKey : String {
		return "AK- Looping Animation"
	}
	
	private var singleAnimationKey : String {
		return "AK- Single Animation"
	}

	/// Runs the animation at the specified rate.
	/// When the animation ends, return to the previous looping animation (if there was one).
	///
	/// - Parameters:
	///   - animationName: Animation to run
	///   - fps: The amount of frames to play each second
	open func runOnce(animation: Animation, fps: Double) {
		guard let primitive = self.gameObject?.primitive else { return }
		
		// save (and then stop) current looping animation
		let previousAnimation = primitive.action(forKey: loopingAnimationKey)
		primitive.removeAction(forKey: loopingAnimationKey)
		
		// construct one-off action
		let frameTime : TimeInterval = 1.0 / fps
		let singleAnimation = SKAction.animate(with: animation.frames, timePerFrame: frameTime)
		let returnToPreviousAnimation = SKAction.run {
			if previousAnimation != nil {
				primitive.run(previousAnimation!, withKey: self.loopingAnimationKey)
			}
		}
		let sequence = SKAction.sequence([singleAnimation, returnToPreviousAnimation])
		
		primitive.run(sequence, withKey: self.singleAnimationKey)
	}
	
	/// Runs the animation on the reciever's sheet, at the specified rate.
	/// When the animation ends, return to the previous looping animation (if there was one).
	///
	/// - Parameters:
	///   - animationName: Name of the animation on the reciever's sheet to run
	///   - fps: The amount of frames to play each second
	open func runOnce(animationNamed animationName: String, fps: Double) {
		guard let animation = self.load(animationNamed: animationName) else { return }
		self.runOnce(animation: animation, fps: fps)
	}
	
	/// Loops the animation at the specified rate.
	///
	/// - Parameters:
	///   - animation: Animation to run
	///   - fps: The amount of frames to play each second
	open func transition(to animation: Animation, fps: Double) {
		guard let primitive = self.gameObject?.primitive else { return }
		
		// cancel a midflight one-off immediately (its `previousAnimation` would be out of date)
		primitive.removeAction(forKey: singleAnimationKey)
		
		// construct a looping action
		let frameTime : TimeInterval = 1.0 / fps
		let singleAnimation = SKAction.animate(with: animation.frames, timePerFrame: frameTime)
		let loopingAnimation = SKAction.repeatForever(singleAnimation)
		
		primitive.run(loopingAnimation, withKey: loopingAnimationKey)
	}
	
	/// Loops the animation on the reciever's sheet, at the specified rate.
	///
	/// - Parameters:
	///   - animationName: Name of the animation on the reciever's sheet to run
	///   - fps: The amount of frames to play each second
	open func transition(toAnimationNamed animationName: String, fps: Double) {
		guard let animation = self.load(animationNamed: animationName) else { return }
		self.transition(to: animation, fps: fps)
	}
	
}

// MARK: - Loading animations
extension Animator {
	
	/// Loads all the specified animations on the reciever's sheet to memory,
	/// accelerating access to them later.
	///
	/// - Parameter animationNames: names of animations to load
	open func cache(animationsNamed animationNames: [String]) {
		for animation in animationNames {
			self.load(animationNamed: animation)
		}
	}
	
	@discardableResult
	private func load(animationNamed animationName: String) -> Animation? {
		if let fromCache = self.animations[animationName] {
			return fromCache
		}
		
		guard let animation = Animation(sheetName: self.sheetName, animationName: animationName)
			else { return nil }
		
		self.animations[animationName] = animation
		return animation
	}
	
}
