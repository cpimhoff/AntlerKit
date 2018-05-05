# AntlerKit Quick Start

## Installation
You can install AntlerKit as a dependency of your project using [Carthage](https://github.com/Carthage/Carthage). Simply specify AntlerKit in your `Cartfile`:
```
github "cimhoff/AntlerKit"
```
Then run `carthage update` and Cartage will fetch and build the latest version of AntlerKit as `AntlerKit.framework` files in `Carthage/Builds/iOS` and `/macOS`.  You can then link these frameworks into your project. If you are unfamiliar with Carthage, check out the [documentation for how to link depedencies into a project](https://github.com/Carthage/Carthage#getting-started).

## Bootstrapping the Initial Scene
AntlerKit supplies a view subclass for both `iOS` and `macOS` to get you started quick. Just hop into your main interface building storyboard and update the base class of your root view to be `AntlerKitView` (remeber to also set _Module_ to `AntlerKit` for this view as well).

In your view controller, you can bootstrap your very first scene into the view:

```swift
import AntlerKit

let akView = self.view as! AntlerKitView
let firstScene = MyFirstScene(size: self.view.bounds.size)
akView.begin(with: firstScene)
```

If you game includes audio playback on `iOS`, you'll also want to call `Audio.configureAudioSession()` before kicking off the scene.

## Your First Scene
Your game is defined in `Scene`s. In this quick start, we'll build a basic scene with a top down view of a red ball. The ball will move to whereever the user taps.

```swift
class MyFirstScene : Scene {
	override func setup() {
    	self.backgroundColor = Color.green    
	}
}
```

A scene's `setup` method is the best place to start configuring the scene's content. We've set the background color, which is a start, but now we actually want content. All entities in a scene are `GameObject`s. `GameObject`s have a position, a visual representation (called a "primitive"), and a set of behaviors (called "components").

We'll define our ball as a new `GameObject` subclass. For now, we'll just define how they look.

```swift
class Ball : GameObject {
	init(radius: CGFloat, color: Color) {
		super.init()
		let circle = SKShapeNode(circleOfRadius: radius)
		circle.fillColor = color
		self.primitive = circle
	}
}
```

`SKShapeNode` is from SpriteKit. SpriteKit is a powerful 2D rendering framework built by Apple avaliable on all platforms that AntlerKit is. AntlerKit uses a lot of SpriteKit's tools as building blocks but unites them in a flexible and robust archatecture. We use SpriteKit nodes to define the basic visuals of AntlerKit objects.









