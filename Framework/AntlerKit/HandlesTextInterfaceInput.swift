//
//  HandlesTextInterfaceInput.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public protocol HandlesTextInterfaceInput {
	
	func handle(textInput text: String) -> Bool
	
}

public extension HandlesTextInterfaceInput {
	
	public func makeTextResponder() {
		_HandlesTextInterfaceInput.currentResponder = self
	}
	
}

internal struct _HandlesTextInterfaceInput {
	
	internal static var currentResponder : HandlesTextInterfaceInput?
	
}
