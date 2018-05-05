//
//  Touch.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import UIKit

/// Information about a touch event
public extension UITouch {
	public var scenePosition : Point {
		return self.location(in: Scene.current.root)
	}
}


/// Information about a touch tap event
public struct TouchTap {
	
	/// The location in the scene that this tap was on
	public var sceneLocation : Point

}
