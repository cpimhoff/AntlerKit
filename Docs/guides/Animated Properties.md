# Animated Properties

Any property of a _GameObject_, _Component_ or _State_ can be wrapped in an `AnimatedProperty` instance to allow for easy and automatic animation.

	class Button : GameObject {
	     var scale : Float = 1.0
	     var animatedScale = AnimatedProperty(defaultDuration: 1, defaultCurve: .ease) { ref in ref(&self.scale) }
	}

When you call `animatedScale.set(2)` the scale property of the button will incrementally update to the value of 2 over the course of 1 second, with an ease-in-out animation curve. 

If the user changes `scale` directly (`button.scale = 0.5`) during an activate animation, the animation is automatically canceled.

## Reference Function
The API of `AnimatedProperty` is a bit unconventional compared to most, so let’s take a moment to unpack it. In order for the `AnimatedProperty` to drive the animation it needs to read the underlying property and to overwrite it on each step of the animation. It needs a safe way to reference the target variable.

In Swift, many of the types we’d want to animate (`Float`, `Color`, etc.) are _value types_, so when they are moved around, they are copied instead of passed by reference. This won’t do for our use case, we do want a dynamic way to read and affect the variable itself, not the value it represents.

When you construct a new `AnimatedProperty`, you are required to pass in a function which yields a reference to the target variable. The mechanism for doing so is to call a function (`ref`) with an `inout` version of the target property (hence the `&`). By yielding the reference via a callback, _Swift_ can ensure that the variable reference is cleaned up (there’s no unsafe pointers being passed around).

If you aren’t comfortable with this API, or want an `AnimatedProperty` to drive a property not represented by a single variable, there is a different version of the constructor available which allows the user to specify a `read -> Value` and a `write(newValue)` separately.

## Animatable Properties
You can bind an `AnimatedProperty` object to _any_ property, so long as the type conforms to `LinearAnimatable`.

`LinearAnimatable` is defined as an extension for the following types:
- `Int`
- `Float`, `CGFloat`
- `Double`
- `Color`