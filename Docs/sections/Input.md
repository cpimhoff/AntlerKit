# Input
Player interaction is handled into two different categories. Interface input allows handling input as in an event driven system, appropriate for UI elements or games with selection based controls. Global input is appropriate for games with more immediate controls, and allows all objects to view the current state of input. 

## Interface Input
Interface input takes precedent over global input and is only sent to relevant GameObjects. These game objects get the first chance to respond to the input, and choose whether or not to allow the input event to propagate to global input. As the name suggests, this style of input is relevant to interface elements, such as buttons or text boxes.

The two inputs delegated as interface events are object selection (a click or tap on an object), and typing out text.

A GameObject or any of its Components can adopt the `HandlesSelectionInterfaceInput` or `HandlesTextInterfaceInput` **event response protocols** to subscribe to relevant inputs.

Selection input is delivered to objects overlapping with a selection event (such as a touch), ordered by z-position. Text input is delivered to the most recent `HandlesTextInterfaceInput` adopter which has called `.makeTextResponder()`.

If no objects handle an interface input event, then the input is passed to global input.

## Global Input
Global input is exposed by polling the static `Input.global` object at any time. Global input contains information relevant to all GameObjects. This includes things like the current tilt of an iOS device, currently active keystrokes, and any interface input that wasn’t handled.