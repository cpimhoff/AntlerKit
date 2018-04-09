# Components
Components define traits and behaviors separately from the GameObjects which utilize them.

This pattern, of adopting behavior through composing components, has significant flexibility benefits as opposed to inheritance and subclassing, and is common in game engines.

## Implementing Behavior
Once a component is attached to a GameObject, it can perform updates on every frame, or respond to GameObject relevant events.

## The Power of Components

## Component Subclasses
`Component` is a plain _protocol_. Two base classes are provided which implement the requirements of the protocol for you. `SimpleComponent` is a pure Swift class, with no extra fluff. `InspectableComponent` is a component which supports some Xcode integration features from _GameplayKit_.

Subclass `SimpleComponent` for your custom components if you don’t need to work with Xcode’s _GameplayKit_ tools.

Subclass `InspectableComponent` if you’d like to use take advantage of the `@GKInspectable` attribute (from _GameplayKit_).

You can implement the `Component` protocol yourself if you’d like a _struct_ or _enum_ to act as a component.