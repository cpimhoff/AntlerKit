//
//  AntlerKitTests.swift
//  AntlerKitTests
//
//  Created by Charlie Imhoff on 1/3/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import XCTest
@testable import AntlerKit

class AntlerKitTests: XCTestCase {
    
    func testPhysicsBodyCategories() {
		let a = PhysicsBodyCategory(uniqueInt1Through32: 1)
		let b = PhysicsBodyCategory(uniqueInt1Through32: 2)
		let c = PhysicsBodyCategory(uniqueInt1Through32: 3)
		let ac : PhysicsBodyCategory = [a, c]
		
		PhysicsBodyCategory.enableCollision(between: a, and: ac)
		PhysicsBodyCategory.enableContacts(between: b, and: ac)
		
		// Collision and contact maps are correctly constructed
		XCTAssertEqual(PhysicsBodyCategory.collisions[a], [a, c])
		XCTAssertNil(PhysicsBodyCategory.collisions[b])
		XCTAssertEqual(PhysicsBodyCategory.collisions[c], [a])
		
		XCTAssertEqual(PhysicsBodyCategory.contacts[a], [b])
		XCTAssertEqual(PhysicsBodyCategory.contacts[b], [a, c])
		XCTAssertEqual(PhysicsBodyCategory.contacts[c], [b])
		
		// Bit masks are synthesized correctly from the collision and contact maps
		XCTAssertEqual(a.collisionBitMask, PhysicsBodyCategory([a, c]).rawValue)
		XCTAssertEqual(b.collisionBitMask, PhysicsBodyCategory.none.rawValue)
		XCTAssertEqual(c.collisionBitMask, PhysicsBodyCategory([a]).rawValue)
		
		XCTAssertEqual(a.contactTestBitMask, PhysicsBodyCategory([b]).rawValue)
		XCTAssertEqual(b.contactTestBitMask, PhysicsBodyCategory([a, c]).rawValue)
		XCTAssertEqual(c.contactTestBitMask, PhysicsBodyCategory([b]).rawValue)
	}
    
}
