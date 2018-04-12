//
//  AnimatedProperty.swift
//  AntlerKit-iOS
//
//  Created by Charlie Imhoff on 4/10/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation

/**
Any property can be wrapped in an `AnimatedProperty` instance to allow for easy and automatic animation.

```
class Button : GameObject {
      var scale : Float = 1.0
      var animatedScale = AnimatedProperty(keyPath: \Button.scale, on: self)
}
```

When you call `animatedScale.set(2, duration: 1)` the scale property of the button will incrementally
update to the value of 2 over the course of 1 second.

If the underlying property is changed directly (`button.scale = 0.5`) during an animation, then the
animation will be automatically canceled.

You can bind an `AnimatedProperty` object to _any_ variable, so long as the type conforms
to `LinearTransitionable`.
*/
public class AnimatedProperty<T: Interpolatable> : UpdatesEachFrame {
	
	internal var getter : () -> T
	internal var setter : (T) -> Void
	
	private var lastGeneratedValue : T?
	private var animationState : AnimatedPropertyState<T>?
	
	/// Initialize a new `AnimatedProperty`, accessing the variable to animate
	/// via _get_ and _set_ closures.
	///
	/// - Parameters:
	///   - getValue: A function to return the current value of the variable being animated
	///   - setValue: A function which sets the variable to a new value
	public init(getValue: @escaping () -> T, setValue: @escaping (T) -> Void) {
		self.getter = getValue
		self.setter = setValue
	}
	
	/// Initialize a new `AnimatedProperty`, accessing the property to animate
	/// via an object and a keypath.
	///
	/// - Parameters:
	///   - keypath: A writable path to the variable to animate.
	///   - object: The object owning the variable. If this instance is being stored
	///             on the same object as the targeted property, then this would be `self`.
	public convenience init<O>(keypath: ReferenceWritableKeyPath<O, T>, on object: O) {
		self.init(getValue: { () -> T in
			return object[keyPath: keypath]
		}, setValue: { newValue in
			object[keyPath: keypath] = newValue
		})
	}
	
	/// Animate the specified property to a new value.
	/// This finishes any inflight animations instantly.
	///
	/// - Parameters:
	///   - destinationValue: The value of the property to animate to.
	///   - duration: The duration of the animation.
	public func animate(to destinationValue: T, duration: TimeInterval) {
		if self.animationState != nil {
			// finalize the previous animation before starting a new one
			setter(self.animationState!.end)
			endAnimation()
		}
		
		self.animationState = AnimatedPropertyState(start: getter(), end: destinationValue, duration: duration)
		Scene.current.startDirectUpdates(self)
	}
	
	internal func internalUpdate(deltaTime: TimeInterval) {
		guard var state = self.animationState else {
			return
		}
		
		let current = getter()
		guard lastGeneratedValue == nil || lastGeneratedValue! == current else {
			// somebody overwrote the value; cancel the animation
			endAnimation()
			return
		}
		
		state.elapsedDuration += deltaTime
		let timeAlpha = min(state.elapsedDuration / state.duration, 1)
		let animationAlpha = timeAlpha  // TODO: support animation curves here
		let newValue = T.interpolate(between: state.start, and: state.end, alpha: Float(animationAlpha))
		lastGeneratedValue = newValue
		setter(newValue)
		
		if newValue == state.end {
			endAnimation()
		} else {
			self.animationState = state
		}
	}
	
	private func endAnimation() {
		self.animationState = nil
		self.lastGeneratedValue = nil
		Scene.current.stopDirectUpdates(self)
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
