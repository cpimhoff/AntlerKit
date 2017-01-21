//
//  Random.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/20/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

public class Random {
	
	static var shared = Random()
	
	var seed : GKRandom
	
	init(seed: GKRandom) {
		self.seed = seed
	}
	
	public enum RandomnessLevel {
		/// Quite random, fairly quick
		case balanced
		/// Less random, but faster
		case fast
		/// Very random, but slower
		case slow
		
		internal var randomSource : GKRandomSource {
			switch self {
			case .balanced:
				return GKARC4RandomSource()
			case .fast:
				return GKLinearCongruentialRandomSource()
			case .slow:
				return GKMersenneTwisterRandomSource()
			}
		}
	}
	
	public enum RandomDistributionType {
		/// All values in the distribution have an equal chance
		case equalOdds
		/// Values in the middle of the distribution have a greater chance than those on the edges
		case bellCurve
		/// Values that have yet to be "drawn" have greater chance
		case shuffled
		
		func distributionSource(with seed: GKRandomSource, lowestValue: Int, highestValue: Int) -> GKRandomDistribution {
			switch self {
			case .equalOdds:
				return GKRandomDistribution(randomSource: seed, lowestValue: lowestValue, highestValue: highestValue)
			case .bellCurve:
				return GKGaussianDistribution(randomSource: seed, lowestValue: lowestValue, highestValue: highestValue)
			case .shuffled:
				return GKShuffledDistribution(randomSource: seed, lowestValue: lowestValue, highestValue: highestValue)
			}
		}
	}
	
	convenience init() {
		self.init(seed: GKARC4RandomSource())
	}
	
	convenience init(uniform level: RandomnessLevel) {
		self.init(seed: level.randomSource)
	}
	
	convenience init(distribution type: RandomDistributionType, level: RandomnessLevel,
	                 lowestValue: Int = 0, highestValue: Int) {
		
		let seed = type.distributionSource(with: level.randomSource,
		                                   lowestValue: lowestValue, highestValue: highestValue)
		self.init(seed: seed)
	}
	
}

extension Random {

	func nextInt() -> Int {
		return self.seed.nextInt()
	}
	
	func nextInt(upperBound: Int) -> Int {
		return self.seed.nextInt(upperBound: upperBound)
	}
	
	func nextBool() -> Bool {
		return self.seed.nextBool()
	}
	
	func nextUniform() -> Float {
		return self.seed.nextUniform()
	}
	
	///Returns a random point inside the given frame
	func nextPoint(inside frame:Rect) -> Point {
		let x = nextInt(upperBound: Int(frame.size.width)) + Int(frame.minX)
		let y = nextInt(upperBound: Int(frame.size.height)) + Int(frame.minY)
		return Point(x: x, y: y)
	}
	
	///Returns a random angle in radians, between 0.0 and 2Pi
	func nextAngle() -> Float {
		return nextUniform() * Float(M_2_PI)
	}
	
	///Returns a random vector with the specified magnitude
	func nextVector(magnitude: CGFloat = 1) -> Vector {
		let x = nextBool() ? CGFloat(nextUniform()) : -CGFloat(nextUniform())
		let y = nextBool() ? CGFloat(nextUniform()) : -CGFloat(nextUniform())
		
		let angleVector = Vector(dx: x, dy: y)
		return angleVector.normalized.scaled(magnitude)
	}
	
}
