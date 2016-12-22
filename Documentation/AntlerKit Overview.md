# AntlerKit Overview

*AntlerKit* provides a streamlined, consistent API for building games on Apple platforms.

## High Level Architecture
### Game Objects
*AntlerKit* uses an [Entity-Component architecture](https://github.com/junkdog/artemis-odb/wiki/Introduction-to-Entity-Systems) to describe the things in the game (`GameObjects`) separate from their behaviors (`Components`). Such a system is common practice in many game frameworks, including *Unity* and *GameplayKit* (which *AntlerKit* uses under the hood).

`GameObjects` also have a collection of `Primitives`, which define how they appear on screen.

### Recipes
Each `GameObject`, no matter what it represents, is then a compilation of reusable elements (`Components` and `Primitives`). It may be tempting to create subclasses for each type of thing a `GameObject` may represent, but this is not recommended.

Instead, think of the *types of things* represented in your game as different “recipes” of simple elements wrapped in a `GameObject`. In the following chart, you can see that we can define a variety of game objects all without subclassing `GameObjects`.

| Recipe | Components | Primitives | Base Class |
|-|-|-|-:|
| Player Spaceship | Movement, TiltControl | *blueShip.png* | **GameObject** |
| Enemy Spaceship | Movement, AIControl | *redShip.png* | **GameObject** |
| Star | *none* | *Circle(color: .white)* | **GameObject** |
| Enemy Base | Spawner | *redBase.png* | **GameObject** |

*Recipes* for defining the core game objects of your game can be defined as an extension on the static `Recipe` class. Then reused simply throughout your game:

```swift
extension Recipe {
	static func playerSpaceShip() -> GameObject {
		let player = GameObject()

		player.add(MovementComponent())
		player.add(TiltControlComponent())
		player.add(Sprite(name:”blueShip”))

		return player
	}
}
```

### Primitives
*AntlerKit* uses Apple’s 2D game library, *SpriteKit*, as a basis for its rendering. *AntlerKit* refers to *SpriteKit* nodes as “primitives”.

Primitives are drawn (or influence what is drawn) on screen but have no support for adding behavior. `GameObjects` use and update a collection of primitives to draw themselves and participate in the physics simulation.

It is advised that developers do not try to handle their own primitives, and instead use the *AntlerKit* APIs on `GameObject` to do so automatically.
