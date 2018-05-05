//
//  SceneTests.swift
//  AntlerKitTests
//
//  Created by Charlie Imhoff on 5/4/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation
@testable import AntlerKit
import XCTest

class SceneTests : XCTestCase {
	
	class TimeCounter : GameObject {
		var time : TimeInterval = 0
		override func update(deltaTime: TimeInterval) {
			self.time += deltaTime
		}
	}
	
	var scene : Scene!
	
	override func setUp() {
		self.scene = Scene(size: CGSize(width: 10, height: 10))
	}
	
	func testSceneUpdatesGameObjects() {
		let timerParent = TimeCounter()
		let timerChild = TimeCounter()
		
		timerParent.add(timerChild)
		self.scene.add(timerParent)
		
		XCTAssertEqual(timerParent.time, 0)
		XCTAssertEqual(timerChild.time, 0)
		self.scene.internalUpdate(deltaTime: 100)
		XCTAssertEqual(timerParent.time, 100)
		XCTAssertEqual(timerChild.time, 100)
	}
	
}
