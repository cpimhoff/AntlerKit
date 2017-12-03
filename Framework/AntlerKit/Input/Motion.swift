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

/// Input for motion data, such as data from the gyroscope
public class Motion {
	
	private let motion : CMMotionManager
	private var zeroPoint : CMAttitude
	
	internal init?() {
		self.motion = CMMotionManager()
		if !motion.isDeviceMotionAvailable {
			return nil		// fail out if this isn't going to work properly...
		}
		self.zeroPoint = CMAttitude()
	}
	
	/// Begin per-frame updates of the device's motion data
	public func beginUpdates() {
		motion.startDeviceMotionUpdates()
	}
	
	/// End per-frame updates of the device's motion data
	public func endUpdates() {
		motion.stopDeviceMotionUpdates()
	}
	
	/// Recalebrate the zero-point of the device by assuming the current state
	/// of the device is the correct zero-point
	public func recalibrateInstantly() {
		guard motion.isDeviceMotionActive
			else { fatalError("Device motion must be started before calebrated") }
		
		self.zeroPoint = self.motion.deviceMotion?.attitude ?? CMAttitude()
	}
	
	public func recalibrate(overTime time: TimeInterval, completion: (() -> Void)?) {
		// TODO: implement
		fatalError("Unimplemented")
	}
	
	/// The current state of the device's motion
	public var reading : MotionReading {
		guard motion.isDeviceMotionActive else {
			fatalError("Readings of the device motion can not be made until the device has begun motion updates.")
		}
		let attitude = self.motion.deviceMotion!.attitude
		attitude.multiply(byInverseOf: self.zeroPoint)
		return MotionReading(pitch: attitude.pitch, roll: attitude.roll, yaw: attitude.yaw)
	}
	
}

/// Information about a device's physical state
public struct MotionReading {
	
	/// The pitch of the device, in radians.
	/// A pitch is a rotation around a lateral axis that passes through the device from side to side.
	public let pitch : Double
	
	/// The roll of the device, in radians.
	/// A roll is a rotation around a longitudinal axis that passes through the device from its top to bottom.
	public let roll : Double
	
	/// The yaw of the device, in radians.
	/// A yaw is a rotation around an axis that runs vertically through the device.
	/// It is perpendicular to the body of the device, with its origin at the center of gravity
	/// and directed toward the bottom of the device.
	public let yaw : Double
	
}

