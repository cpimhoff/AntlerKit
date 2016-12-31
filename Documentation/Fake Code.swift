
import AntlerKit

typealias Seconds = Float

class GameScene : Scene {

	var score : Float = 0
	var scoreText : TextObject!

	func setup() {
		let player = PlayerSpaceship()
		player.position = self.screen.centerPoint

		let spawner = Spawner(spawns: EnemySpaceship, interval: 3)
		spawner.position = self.screen.topLeftPoint

		self.scoreText = TextObject("Score: \(score)")

		self.add(player)
		self.add(spawner)
		self.add(scoreText)
	}

	func tick(delta: Seconds) {
		self.score += delta
		self.scoreText.text = "Score: \(score)"
	}

}

class PlayerSpaceship : GameObject {

	init() {
		super.init()

		let movement = MovementComponent()
		self.add(movement)
		let tiltController = TiltControlComponent()
		self.add(tiltController)

		self.primitive = Sprite(named: "spaceship")
		self.primitive.color = .blue

		self.body = PhysicsBody(circleOfRadius: 5, category: .player)
	}

	// Events

	override func onCollision(with other: GameObject) {
		if other is EnemySpaceship {
			self.destroy()
		}
	}

}
