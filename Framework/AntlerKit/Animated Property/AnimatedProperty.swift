//
//  AnimatedProperty.swift
//  AntlerKit-iOS
//
//  Created by Charlie Imhoff on 4/10/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation

public class AnimatedProperty<T: LinearTransitionable> {
	
	internal var getter : () -> T
	internal var setter : (T) -> Void
	
	private var lastGeneratedValue : T?
	private var animationState : AnimatedPropertyState<T>?
	
	public init(getValue: @escaping () -> T, setValue: @escaping (T) -> Void) {
		self.getter = getValue
		self.setter = setValue
	}
	
	public convenience init<O>(keypath: ReferenceWritableKeyPath<O, T>, on object: O) {
		self.init(getValue: { () -> T in
			return object[keyPath: keypath]
		}, setValue: { newValue in
			object[keyPath: keypath] = newValue
		})
	}
	
	open func set(_ newValue: T, duration: TimeInterval) {
		if self.animationState != nil {
			// finalize the previous animation before starting a new one
			setter(self.animationState!.end)
			lastGeneratedValue = nil
		}
		
		self.animationState = AnimatedPropertyState(start: getter(), end: newValue, duration: duration)
	}
	
	internal func update(deltaTime: TimeInterval) {
		guard var state = self.animationState else {
			return
		}
		
		let current = getter()
		guard lastGeneratedValue == nil || lastGeneratedValue! == current else {
			// somebody overwrote the value; cancel the animation
			self.animationState = nil
			lastGeneratedValue = nil
			return
		}
		
		state.elapsedDuration += deltaTime
		let timeAlpha = min(state.elapsedDuration / state.duration, 1)
		let animationAlpha = timeAlpha  // TODO: support animation curves here
		let newValue = T.interpolate(between: state.start, and: state.end, alpha: Float(animationAlpha))
		lastGeneratedValue = newValue
		setter(newValue)
		
		if newValue == state.end {
			self.animationState = nil
		} else {
			self.animationState = state
		}
	}
	
}

private struct AnimatedPropertyState<T> {
	let start : T
	let end : T
	let duration : TimeInterval
	
	var elapsedDuration : TimeInterval = 0
	
	init(start: T, end: T, duration: TimeInterval) {
		self.start = start
		self.end = end
		self.duration = duration
	}
}
