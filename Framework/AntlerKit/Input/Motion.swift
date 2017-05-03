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
	
	fileprivate let motion : CMMotionManager
	fileprivate var zeroPoint : CMAttitude
	
	init?() {
		self.motion = CMMotionManager()
		if !motion.isDeviceMotionAvailable {
			return nil		// fail out if this isn't going to work properly...
		}
		self.zeroPoint = CMAttitude()
		self.recalibrateInstantly()
	}
	
	public func beginUpdates() {
		motion.startDeviceMotionUpdates()
	}
	
	public func endUpdates() {
		motion.stopDeviceMotionUpdates()
	}
	
	public func recalibrateInstantly() {
		self.zeroPoint = self.motion.deviceMotion!.attitude
	}
	
	public func recalibrate(overTime time: TimeInterval, completion: (() -> Void)?) {
		// TODO: improper impl.
		self.recalibrateInstantly()
	}
	
	public var reading : MotionReading {
		let attitude = self.motion.deviceMotion!.attitude
		attitude.multiply(byInverseOf: self.zeroPoint)
		
		return MotionReading(pitch: attitude.pitch, roll: attitude.roll, yaw: attitude.yaw)
	}
	
}

public struct MotionReading {
	
	let pitch : Double
	let roll : Double
	let yaw : Double
	
}

