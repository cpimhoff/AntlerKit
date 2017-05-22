//
//  Random.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/20/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

public struct Random {
	
	public static var shared = Random()
	
	fileprivate var seed : GKRandom
	
	public init(seed: GKRandom) {
		self.seed = seed
	}
	
	public init(quality: RandomnessQuality = .default) {
		self.init(seed: quality.randomSource)
	}
	
	public init(distribution type: RandomDistributionType, quality: RandomnessQuality = .default,
	                 lowest: Int, highest: Int) {
		
		let seed = type.distributionSource(with: quality.randomSource,
		                                   lowestValue: lowest, highestValue: highest)
		self.init(seed: seed)
	}
	
}

public extension Random {

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

public enum RandomnessQuality {
	/// Quite random, pretty quick
	case `default`
	/// Less random, but faster
	case fastResults
	/// Very random, but slower
	case highQuality
	
	internal var randomSource : GKRandomSource {
		switch self {
		case .default:
			return GKARC4RandomSource()
		case .fastResults:
			return GKLinearCongruentialRandomSource()
		case .highQuality:
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
	
	internal func distributionSource(with seed: GKRandomSource, lowestValue: Int, highestValue: Int) -> GKRandomDistribution {
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
