# AntlerKit Overview

*AntlerKit* provides a streamlined, consistent API for building games on Apple platforms.

It integrates and provides a simple to manage bridge between powerful Apple tools, as well as provide the core gameplay functionality Apple left out. 

## High Level Architecture
### Game Objects
*AntlerKit* uses an [Entity-Component architecture](https://github.com/junkdog/artemis-odb/wiki/Introduction-to-Entity-Systems) to describe the things in the game (`GameObjects`) separate from their behaviors (`Components`). Such a system is common practice in many game frameworks, including *Unity* and *GameplayKit* (which *AntlerKit* uses under the hood).

`GameObjects` also each have a `Primitive`, which defines how they appear on screen.

Each `GameObject`, no matter what it represents, is then a compilation of reusable elements (`Components` and `Primitives`).

`GameObjects` can be arranged in a hierarchy. Transformations applied to a parent game object apply to their children as well. For example, a spaceship `GameObject` may have a crew member as a child. If the spaceship moves, the crew member will move with it, but the crew member is also free to move around the spaceship.

### Primitives
*AntlerKit* uses Apple’s 2D game library, *SpriteKit*, as a basis for its rendering. *AntlerKit* refers to *SpriteKit* nodes as “primitives”.

Primitives are drawn (or influence what is drawn) on screen but have no support for adding behavior. `GameObjects` automatically manage their own primitives, including syncing their location and properties to other subsystems.

Primitives also support hierarchies in the same way that `GameObjects` do if you use the SpriteKit methods exposed on the `Primitive` class.

### Scenes
A scene manages a collection of GameObjects and positions them in a world. A finished game can be made up of a variety of different scenes. A scene can also be thought of as a “level”, or “mission” in a linear game. Arcade games will likely have a scene for each mode.

Only a single scene is updated or rendered at a time.

The scenes are arranged on a stack, so you can transition to a new scene by “pushing”, which will pause and preserve the state of the previous scene for when you “pop“ back. Alternatively, you can “switch” to a new scene entirely, which swaps out the current item on the stack with the new scene (but preserved the previous scenes on the stack).

```
start 'Main Menu'
			Main Menu
push 'Level 1'
			Main Menu >> Level 1
switch 'Level 2'
			Main Menu >> Level 2
pop
			Main Menu
```

### Input
Player interaction is handled into two different categories. Global and interface.

#### Interface Input
Interface input takes precedent over global input and is only exposed to relevant `GameObjects`. These game objects get the first chance to respond to the input, and choose whether or not to allow the input event to propagate to global input. As the name suggests, this style of input is relevant to interface elements, such as buttons or text boxes.

The two inputs delegated as interface events are object selection (click or tap on an object), and text typing.

A `GameObject` (or any of its components) can adopt the `HandlesSelectionInterfaceInput` or `HandlesTextInterfaceInput` protocols to subscribe to relevant inputs.

Selection input is delivered to objects overlapping with a selection input, ordered by z-position. Text input is delivered to the most recent `HandlesTextInterfaceInput` adopter which has called `.makeTextResponder()`.

If no objects subscribe to interface input events, then all input is sent to global input.

#### Global Input
Global input is exposed via querying the static `Input.global` object at any time. Global input contains information relevant to all `GameObjects`. This includes things like the current tilt of an iOS device, or currently active keystrokes, or any interface input that wasn’t handled.

### 
