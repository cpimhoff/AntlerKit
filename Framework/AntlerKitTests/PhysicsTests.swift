//
//  PhysicsTests.swift
//  AntlerKitTests
//
//  Created by Charlie Imhoff on 5/4/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import XCTest
import SpriteKit
@testable import AntlerKit

class PhysicsTests: XCTestCase {
	
	var category1 : PhysicsBodyCategory!
	var category2 : PhysicsBodyCategory!
	var category3 : PhysicsBodyCategory!
	var oddCategory : PhysicsBodyCategory!
	
	override func setUp() {
		self.category1 = PhysicsBodyCategory(uniqueInt1Through32: 1)
		self.category2 = PhysicsBodyCategory(uniqueInt1Through32: 2)
		self.category3 = PhysicsBodyCategory(uniqueInt1Through32: 3)
		self.oddCategory = [category1, category3]
	}
	
	func testPhysicsBodyCategoryEnableCollision() {
		PhysicsBodyCategory.enableCollision(between: category1, and: oddCategory)
		
		// Collision maps are correctly constructed
		XCTAssertEqual(PhysicsBodyCategory.collisions[category1], [category1, category3])
		XCTAssertNil(PhysicsBodyCategory.collisions[category2])
		XCTAssertEqual(PhysicsBodyCategory.collisions[category3], [category1])
		
		// Bit masks are synthesized correctly base on the collision map
		XCTAssertEqual(category1.collisionBitMask, PhysicsBodyCategory([category1, category3]).rawValue)
		XCTAssertEqual(category2.collisionBitMask, PhysicsBodyCategory.none.rawValue)
		XCTAssertEqual(category3.collisionBitMask, PhysicsBodyCategory([category1]).rawValue)
	}
	
	func testPhysicsBodyCategoryEnableContacts() {
		PhysicsBodyCategory.enableContacts(between: category2, and: oddCategory)
		
		// Contact maps are correctly constructed
		XCTAssertEqual(PhysicsBodyCategory.contacts[category1], [category2])
		XCTAssertEqual(PhysicsBodyCategory.contacts[category2], [category1, category3])
		XCTAssertEqual(PhysicsBodyCategory.contacts[category3], [category2])
		
		// Bit masks are synthesized correctly based on the contact map
		XCTAssertEqual(category1.contactTestBitMask, PhysicsBodyCategory([category2]).rawValue)
		XCTAssertEqual(category2.contactTestBitMask, PhysicsBodyCategory([category1, category3]).rawValue)
		XCTAssertEqual(category3.contactTestBitMask, PhysicsBodyCategory([category2]).rawValue)
	}
	
	func testSpriteKitPhysicsBodyIntegration() {
		PhysicsBodyCategory.enableCollision(between: category1, and: oddCategory)
		
		let physicsBody = SKPhysicsBody(circleOfRadius: 1)
		physicsBody.category = self.oddCategory
		
		XCTAssertEqual(physicsBody.categoryBitMask, self.oddCategory.categoryBitMask)
		XCTAssertEqual(physicsBody.collisionBitMask, self.oddCategory.collisionBitMask)
		XCTAssertEqual(physicsBody.contactTestBitMask, self.oddCategory.contactTestBitMask)
	}
	
}
