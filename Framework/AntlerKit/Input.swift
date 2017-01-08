//
//  Input.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

#if os(iOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif


open class Input {
	
	open static var global = Input()
	
	#if os(iOS)
	open var touches = [Touch]()
	
	// var deviceTilt...
	#endif
	
	#if os(OSX)
	open var activeKeys = Set<String>()
	
	open var cursor = Cursor()
	#endif
	
}
