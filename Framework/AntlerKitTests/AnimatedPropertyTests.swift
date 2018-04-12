//
//  AnimatedPropertyTests.swift
//  AntlerKitTests
//
//  Created by Charlie Imhoff on 4/11/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import XCTest
@testable import AntlerKit

class AnimatedPropertyTests: XCTestCase {
	
	var target : Float = 10.0
	var animatedTarget : AnimatedProperty<Float>!
	
	override func setUp() {
		self.animatedTarget = AnimatedProperty(
			getValue: { return self.target },
			setValue: { newValue in self.target = newValue }
		)
	}
	
	func testGetSetInitializer() {
		animatedTarget.setter(15.0)
		XCTAssertEqual(animatedTarget.getter(), 15.0)
		XCTAssertEqual(target, 15.0)
	}
	
	func testKeyPathInitializer() {
		self.animatedTarget = AnimatedProperty(keypath: \AnimatedPropertyTests.target, on: self)
		
		self.animatedTarget.setter(5.0)
		XCTAssertEqual(self.animatedTarget.getter(), 5.0)
		XCTAssertEqual(self.target, 5.0)
	}
	
	func testAnimate() {
		target = 0
		animatedTarget.animate(to: 10, duration: 4)
		
		animatedTarget.internalUpdate(deltaTime: 1)
		XCTAssertEqual(target, 2.5)
		
		animatedTarget.internalUpdate(deltaTime: 1)
		XCTAssertEqual(target, 5.0)
		
		animatedTarget.internalUpdate(deltaTime: 0.5)
		XCTAssertEqual(target, 6.25)
		
		// overshooting should clamp to the destination
		animatedTarget.internalUpdate(deltaTime: 2)
		XCTAssertEqual(target, 10.0)
		
		// animation is diabled afterwards
		target = 20
		animatedTarget.internalUpdate(deltaTime: 1)
		XCTAssertEqual(target, 20)
	}
	
	func testAnimateOverride() {
		animatedTarget.animate(to: 20, duration: 2)
		
		// tick the update by a second. We are halfway through animation
		animatedTarget.internalUpdate(deltaTime: 1)
		
		// override the variable mid-animation, this should cancel the inflight animation
		target = 5.0
		
		// ticking the animation should no longer affects the target variable
		animatedTarget.internalUpdate(deltaTime: 1)
		XCTAssertEqual(target, 5.0)
		animatedTarget.internalUpdate(deltaTime: 1)
		XCTAssertEqual(target, 5.0)
	}
	
}
