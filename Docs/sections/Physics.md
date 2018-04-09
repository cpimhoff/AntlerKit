# Physics
*AntlerKit* uses *SpriteKit*’s physics implementation under the hood, but builds on it to allow for easier use and clearer code.

## Defining Physics
To participate in physics, simply assign an `SKPhysicsBody` to any `GameObject.body` property. *AntlerKit* will automatically bind the body to the proper underlying primitive, and sync updates between them and other subsystems.

`Scene.physicsWorld` allows configuration of the physical environment (such as gravity) in a scene.

## Categories
Every physics body is assigned a `PhysicsBodyCategory`. *AntlerKit* uses the categories of physics objects to determine how objects should interact with one another.

> In *AntlerKit* a **collision** is when two objects’ bodies bump into and exert force on one another. A **contact** is when two objects’ bodies touch and relevant subscribers are notified (ie. developer code is called).

Developers must enable collisions or contacts between any two physics categories they wish to interact. In general, the more collisions and contacts are defined, the more work the physics system has to do.

To enable a collision or contact between two categories, use the static methods `PhysicsBodyCategory.enableCollision(...)` or `PhysicsBodyCategory.enableContacts(...)`. You only need to enable each collision or contact once in the lifecycle of the app (such as at launch).

### Extending Categories
To define your own categories, you can extend `PhysicsBodyCategory` like any `OptionSet`:
	extension PhysicsBodyCategory {
		public static let enviroment = PhysicsBodyCategory(rawValue: 1 << 0)
		public static let deadly = PhysicsBodyCategory(rawValue: 1 << 1) 
	}

Then, a GameObject such as a spike trap can be set up as such:
	spikesTrap.body.category = [.enviroment, .deadly]

Only 32 base categories can be defined because a `UInt32` bit-mask is used to implement the category system.

## Contacts
Conformance to `RespondsToContact` allows a GameObject and its Components to respond to a physics contact event between it and another object.

See **event response protocols** for more information.