# Primitives
*AntlerKit* uses Apple’s 2D game library, *SpriteKit*, as a basis for its rendering. *AntlerKit* refers to *SpriteKit* nodes as “primitives”.

Primitives are drawn onscreen but have no support for adding behavior. `GameObjects` automatically manage their own primitives, like syncing their location and properties to other subsystems.

In *AntlerKit*, the term “primitive” applies to `SKNode` and all its subclasses.

The term “primitive” is chosen here to express that they combine together to represent more complex objects. A visual sprite knows nothing of the behavior associated to it, nor its relation to other objects. Intentionally little API is exposed to directly interact with primitives, since they don’t naturally coordinate with higher level systems. *AntlerKit* takes the stance that primitives should be specified by the designer, but not handled by the developer. *AntlerKit* takes care of that work for you, allowing developers to focus on the more complex, interesting behavior of the game.