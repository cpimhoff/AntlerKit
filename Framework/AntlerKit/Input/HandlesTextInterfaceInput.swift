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

extension GameObject : HandlesTextInterfaceInput {
	
	public func handle(textInput text: String) -> Bool {
		for c in self.enabledComponents {
			if let handler = c as? HandlesTextInterfaceInput {
				if handler.handle(textInput: text) {
					return true
				}
			}
		}
		
		// nobody handled it
		return false
	}
	
}
