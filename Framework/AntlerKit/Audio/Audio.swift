//
//  Audio.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/30/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

class Audio {

	static var music : Music?
		// plays a sound independent of scenes, so transitions don't cut sound
	
	static func play(_ sound: Sound, volume: Float = 1.0) {
		// play a sound via SKAction (bound to scene)
	}
	
}
