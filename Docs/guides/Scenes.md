# Scenes
A `Scene` manages a collection of GameObjects and positions them in a world. A finished game can be made up of a variety of different scenes. Only a single scene is updated or rendered at a time.

## Scene Management
Scenes are arranged on a stack, so you can transition to a new scene by “pushing”, which will pause and preserve the state of the previous scene for when you “pop“ back. Alternatively, you can “switch” to a new scene entirely, which swaps out the current item on the stack with the new scene (but preserved the previous scenes on the stack).

	start 'Main Menu'
		Main Menu
	push 'Level 1'
		Main Menu >> Level 1
	switch 'Level 2'
		Main Menu >> Level 2
	pop
		Main Menu