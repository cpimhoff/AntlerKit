# Game Objects
*AntlerKit* uses an [Entity-Component architecture](https://github.com/junkdog/artemis-odb/wiki/Introduction-to-Entity-Systems) to separate the objects in the game (`GameObjects`) from their behaviors (`Components`). Such a system is common practice in many game frameworks, including *Unity* and *GameplayKit* (which *AntlerKit* uses under the hood).

Each `GameObject`, no matter what it represents, is then a compilation of reusable elements. A `GameObject`’s behavior is defined as a list of configurable `Components`, and its visual representation in the game world are made up of _primitives_.

`GameObjects` can be arranged in a hierarchy. Transformations applied to a parent game object apply to their children as well. For example, a spaceship `GameObject` may have a crew member as a child. If the spaceship moves, the crew member will move with it, but the crew member is also free to move around the spaceship.

## Reusing GameObjects
You should subclass `GameObject` to provide convenient initialization of commonly used types of `GameObject`. However, it is advised that a subclass of `GameObject` contains only an initializer, and as much behavioral code as possible (hopefully all of it) should be factored into the `GameObject`’s components so it can be reused.

This pattern effectively functions as a factory system (as nothing beside a initializer is modified), but has the added benefit of associating a type to the instances you create. This way, you can still make natural queries about the kinds of things in the game: `if hitObject is Astroid { ... }`.

For example:

	class PlayerSpaceship : GameObject {
	    override init() {
	        super.init()  // required
	        // define components
	        let movement = MovementComponent()
	        movement.speed = 10
	        let control = TiltControls()
	        control.target = movement
	        self.add(movement)
	        self.add(control)
	
	        // define visuals
	        self.primitive = Sprite(named: "blueSpaceship")
	
	        // define physics
	        self.body = PhysicsBody(circleWithRadius: 5)
	        self.bodyCategroy = .player
	    }
	}
