# State Machines

*AntlerKit* provides its own state machine implementation which easily hooks into the rest of the architecture.

State machines are especially powerful in defining the behavior of an entity which can take multiple non-instantaneous actions, because the definition of each action is separated from the logic which determines which action to take. This also means that individual actions can be reused by other entities and other complex behaviors.

## Example and Motivation
Imagine we have an enemy in a stealth game. We want the enemy to patrol back and forth, and when they spot the player, they should chase them. If they lose sight of the player for a few seconds, they return to their patrol.

Implementing this behavior in a single function could prove difficult, because we have to manage a lot of state to determine if we are currently patrolling, chasing the player, or returning. We then need a lot of branching on that state information to decide what action to take. This is hard to reason about and difficult to extend if we wanted to make the logic more nuanced. We can’t share behavior to other game objects either. If we wanted to introduce a ghost enemy which _always_ pursued the player, we’d have trouble pulling that logic out without introducing code duplication. Finally, we have a lot of state which is only actually needed and useful in certain situations, which can cause bugs and confusion. During patrol, we need access to some locations to determine our guarding route. But that information is completely irrelevant when chasing the player.

By using State Machines, we’ll be able to solve all these problems.

We can illustrate the enemy’s behavior with a graph, in which the nodes represent the action the enemy is taking, and the edges represent the event that triggers the enemy to change behavior.


This behavior can be easily constructed using a state machine, where each action is a state, and each edge is a transition.

The first state, the `PatrolState` only defines logic for patrolling between two points. The `ChaseState` defines logic to chase a given player. The `WaitState` defines logic for waiting to return to patrol after losing sight of the player. Finally the `ReturnState` returns the enemy to his patrol location.

Each state completely encapsulates its own logic, reducing the amount of variables any own state needs to be concerned with, as well as greatly simplify branching. Each state can be shared too. The ghost enemy alluded to earlier can be defined with a trivial state machine with one state: `ChaseState`.

## API
A `StateMachine` takes a set of `State` instances as arguments. A `StateMachine` can then be attached to a `GameObject` as a component.

`StateMachines` always begin with the first state provided in the call to the initializer.

A `State` can adopt all the **event response protocols** a `Component` can, as well as perform per-frame updates. In fact, each state is a `Component`, and can be attached directly to a `GameObject` if it doesn't need to be hooked into a larger behavior.

A `State` can override `.isNextStateAllowed(nextState)` to define what states are allowed to follow this one. If the function is undefined, all possible next states are approved.

A state can also hook into the following lifecycle events:
- `didAttach(to stateMachine: StateMachine)`
- `didTransition(from previousState: State?)`
- `willTransition(to nextState)`

Call `stateMachine.signalTransition(to: State.self)` to request a state machine transfer to a different state class. Since the current `State` is queried to ensure this is a valid transition (or the supplied state may not actually be a member of the receiver), this transition may not always occur. In either of those cases, `false` is returned.

## State Inheritance
All methods on `StateMachine` which take a `State` as a parameter can also take a superclass or a protocol to allow for more polymorphic composition, and reduced dependency between `State` classes.

Imagine we have two more enemies, which, instead of chasing the player, attack the player with special abilities. One uses a spear, the other uses a magic fireball.


The attack states `ThrowSpearState` and `CastFireballState` are symmetric to one another in that they both are transitioned to by `PatrolState` spotting the player. They both offer the same role in terms of the composite behavior, but are implemented differently.

However, in `PatrolState` what do we call in order to validly transition to both of these distinct other states? Instead of referencing these states by their concrete subclass, we can instead reference them by a shared superclass.

We subclass `ThrowSpearState` and `CastFireballState` from a new `AttackState` superclass (`AttackState` can also be defined as a protocol which implements `StateMachineAbstractState`). We can then call `stateMachine.signalTransition(to: AttackState.self)` in `PatrolState`. When the state machine is configured with a `ThrowSpearState`, this call will transition to `ThrowSpearState`. If it is configured with `CastFireballState`, this call will transition to `CastFireballState` instead. If the state machine is configured with _both_ classes, then the machine will transition to the first one specified at initialization.

By utilizing state inheritance, you can create truly compossible states and state machines, allowing you to rapidly develop and experiment with complex behaviors.
