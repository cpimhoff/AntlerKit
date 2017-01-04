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
		let a = PhysicsBodyCategory.enviroment
		let b : PhysicsBodyCategory = [.static, .effect]
		
		PhysicsBodyCategory.enableCollision(between: a, and: b)
		PhysicsBodyCategory.enableContact(between: .static, and: .enviroment)
		
		//// === COLLISION ===
		// enviroment:	- static
		//				- effect
		// static:	- enviroment
		// effect:	- enviroment
		
		//// === CONTACT ===
		// enviroment:	- static
		// static:	- enviroment
		// effect:	none
		
		XCTAssertEqual(PhysicsBodyCategory.collisions[.enviroment], [.static, .effect])
		XCTAssertEqual(PhysicsBodyCategory.collisions[.static], [.enviroment])
		XCTAssertEqual(PhysicsBodyCategory.collisions[.effect], [.enviroment])
		
		XCTAssertEqual(PhysicsBodyCategory.contacts[.enviroment], [.static])
		XCTAssertEqual(PhysicsBodyCategory.contacts[.static], [.enviroment])
		XCTAssertNil(PhysicsBodyCategory.contacts[.effect])
		
		XCTAssertEqual(PhysicsBodyCategory.enviroment.collisionBitMask,
		               ([.static, .effect] as PhysicsBodyCategory).rawValue)
		XCTAssertEqual(PhysicsBodyCategory.static.collisionBitMask,
		               ([.enviroment] as PhysicsBodyCategory).rawValue)
		XCTAssertEqual(PhysicsBodyCategory.effect.collisionBitMask,
		               ([.enviroment] as PhysicsBodyCategory).rawValue)
		
		XCTAssertEqual(PhysicsBodyCategory.enviroment.contactTestBitMask,
		               ([.static] as PhysicsBodyCategory).rawValue)
		XCTAssertEqual(PhysicsBodyCategory.static.contactTestBitMask,
		               ([.enviroment] as PhysicsBodyCategory).rawValue)
		XCTAssertEqual(PhysicsBodyCategory.effect.contactTestBitMask,
		               ([.none] as PhysicsBodyCategory).rawValue)
	}
    
}
