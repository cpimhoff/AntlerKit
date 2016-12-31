
protocol GameObject {

	public init()
	
	public final var position : Point { get set }
	
	public final func add(component: Component)
	public final func add(child: GameObject)
	
	public final var primitive : Primitive { get set }
	public final var body : PhysicsBody { get set }
	
	//
	//	Event Hooks
	//
	public func update(delta: Seconds)		// override point
	
}

