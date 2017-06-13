//
//  Motion.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 5/2/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import CoreMotion
import CoreGraphics

public class Motion {
	
	private let motion : CMMotionManager
	private var zeroPoint : CMAttitude
	
	init?() {
		self.motion = CMMotionManager()
		if !motion.isDeviceMotionAvailable {
			return nil		// fail out if this isn't going to work properly...
		}
		self.zeroPoint = CMAttitude()
	}
	
	public func beginUpdates() {
		motion.startDeviceMotionUpdates()
	}
	
	public func endUpdates() {
		motion.stopDeviceMotionUpdates()
	}
	
	public func recalibrateInstantly() {
		guard motion.isDeviceMotionActive
			else { fatalError("Device motion must be started before calebrated") }
		
		self.zeroPoint = self.motion.deviceMotion?.attitude ?? CMAttitude()
	}
	
	public func recalibrate(overTime time: TimeInterval, completion: (() -> Void)?) {
		// TODO: improper impl.
		self.recalibrateInstantly()
	}
	
	public var reading : MotionReading? {
		guard let attitude = self.motion.deviceMotion?.attitude
			else { return nil }
		
		attitude.multiply(byInverseOf: self.zeroPoint)
		return MotionReading(pitch: attitude.pitch, roll: attitude.roll, yaw: attitude.yaw)
	}
	
}

public struct MotionReading {
	
	public let pitch : Double
	public let roll : Double
	public let yaw : Double
	
}

