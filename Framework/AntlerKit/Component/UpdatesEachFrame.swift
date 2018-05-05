//
//  UpdatesEachFrame.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/11/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation

public protocol UpdatesEachFrame : AnyObject {
	
	/// Called every frame. Override to provide behavior.
	///
	/// - Parameter deltaTime: The time, in seconds, between the last frame and this current one.
	func update(deltaTime: TimeInterval)
	
}

internal protocol InternalUpdatesEachFrame : UpdatesEachFrame {
	
	/// Internally, per frame updates sometimes need to do more than just call the user's update code,
	/// such as share update information with related objects like children.
	///
	/// Since Swift has no current method to enforce that subclasses call the super version of overridden
	/// methods, we use `update` to mean "user supplied updates", and this `internalUpdate` as the main place
	/// any AntlerKit system should call out to an object to udate.
	func internalUpdate(deltaTime: TimeInterval)
	
}
