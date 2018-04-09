# Frame Based Animation
_AntlerKit_ provides a streamlined system to animate sprites over a sequence of frames.

## Sheets, Animations, and Frames
_AntlerKit_ breaks the process of specifying an animation into a series of different concepts.

**Frame:** a single image or texture. Multiple frames played in sequence create the illusion of an animated sprite.
**Animation:** a set of frames which, when played in sequence, create the illusion of an animated sprite.
**Sheets:** a grouping of animations which are related by a common visual object.

For example: a sheet named “blue player” may contain animations for “idle”, “jump”, and “walk”. Another sheet, named “red enemy”, may also have a “walk” animation, but these two “walk“ animations are distinct, because they are animating different visual objects.

## Working with GameObjects
A single `Animator` is associated with a single `GameObject`, and can only load a single sheet at a time. This is logical, as a single game object’s base primitive should remain the same over the course of a series of animations.

This also allows some polymorphism with triggering similarly named animations. If you have a “jump” animation for both players and enemies, you can trigger a “jump” animation from a component, without needing to know whether the owning GameObject is representing the “blue player” or “red enemy“ sheet.

	player.animator = Animator(sheetName: "player")
	player.animator.transition(toAnimationNamed: "idle")
	// later on...
	player.animator.transition(toAnimationNamed: "jump")

## Sheets and Frame Naming
In order for _AntlerKit_ to properly load animations and sheets, naming conventions must be followed. _AntlerKit_ loads images and sprites stored in your app’s asset catalogue (main bundle). Each image must be named according to the following:

`sheet-animation-#`

For example: if you specify the “jump” animation while on the “player“ sheet, _AntlerKit_ will search for a frame image named “player-jump-0”. If this frame is loaded correctly, the search will continue to “player-jump-1“, and so on, until the entire animation is loaded.

Note that because _AntlerKit_ parses the sections of the frame name by splitting on the `-` character, you can not use `-` in your sheet or animation names.