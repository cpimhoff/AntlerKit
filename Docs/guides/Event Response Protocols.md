# Event Response Protocols

There are a variety of events that occur to GameObjects that you may want to be notified on. *AntlerKit* uses a set of event response protocols to allow GameObjects and their components to statically define the set of events they need to respond to.

Event response protocols can be conformed to by `GameObject`, `Component`, or `State` subclasses to act on relevant events.

A game object will propagate a relevant event to its components implementing the associated response protocol, even if the game object itself doesn’t implement the protocol.

## Input
Conformance to `HandlesSelectionInterfaceInput` allows a GameObject (or its Components) to respond when the user taps or clicks within its bounding box.

Conformance to `HandlesTextInterfaceInput` allows a responder to call `.makeTextResponder()` and `.resignTextResponder()`. The active text responder’s `handle(textInput:)` is then called when the user types.

## Physics
Conformance to `RespondsToContact` allows a GameObject and its Components to respond to physics contacts between it and another object.

> Note: This just subscribes objects to contact events. To _create_ contact events, contacts must be enabled between the two body categories of the GameObjects contacting one another. Use `PhysicsBodyCategory.enableContacts(between: , and:)` to enable contacts between two physics body types.