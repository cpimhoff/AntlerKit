//
//  HandlesSelectionInterfaceInput.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/7/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

public protocol HandlesSelectionInterfaceInput {
	
	func handleSelected() -> Bool
	
//	var selectionBoundingBox : Size { get }
	
}

extension GameObject : HandlesSelectionInterfaceInput {
	
	public func handleSelected() -> Bool {
		for c in self.allComponents {
			if let handler = c as? HandlesSelectionInterfaceInput {
				if handler.handleSelected() {
					return true
				}
			}
		}
		
		// nobody handled it
		return false
	}
	
}
