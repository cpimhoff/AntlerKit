
# Best Practices
### Reusing GameObjects
You should subclass `GameObject` to provide convenient initialization of commonly used types of `GameObject`. However, it is advised that a subclass of `GameObject` contains only an initializer, and as much behavioral code as possible (hopefully, all of it) is factored into the `GameObject`’s components (so it can be reused).

For example:
```swift
class PlayerSpaceship : GameObject {
	override init() {
		super.init()
		
		// define components
		let movement = MovementComponent()
		movement.speed = 10
		let control = TiltControls()
		control.actor = movement
		self.add(movement)
		self.add(control)
		
		// define visuals
		self.primitive = Sprite(named: "blueSpaceship")
		
		// define physics
		self.body = PhysicsBody(circleWithRadius: 5)
		self.bodyCategroy = .player
	}
}
```

### Controller and Actor Components
Lots of `GameObjects` do things, and lots of `GameObjects` have those actions be *motivated* by something. *The taking of an action should be separated from the mechanism which invokes that action.*

For a good examination of this practice, have a look at the following group of related built-in components:

| Component | Provides | Description |
|:--|:--|:--|
| `MovementComponent` | Action | Moves each frame based on a x,y velocity or target location |
| `TiltControlsComponent` | Input Control | Updates `MovementComponent`’s velocities based on current device tilt |
| `ChaseComponent` | AI Control | Updates `MovementComponent`’s target location based on the location of some target |
| `TapDestinationComponent` | Input Control | Updates `MovementComponent`’s target location based on the location of user touches and draws a visible flag for the current destination |

This group of components provides a flexible set of different methods to move a game object around the world, either using input or automatic behavior. This means that enemies controlled by the AI can use the same movement code as a player’s agent in the game, or that swapping out a control style for the player is as simple as swapping which component is added to the player (great for building a cross-platform game).