//
//  Enviroment.swift
//  AntlerKitTests
//
//  Created by Charlie Imhoff on 4/12/18.
//  Copyright © 2018 Charlie Imhoff. All rights reserved.
//

import Foundation

internal struct Enviroment {
	
	static var isTesting : Bool {
		return ProcessInfo.processInfo.environment["TESTING"] == "true"
	}
	
}
