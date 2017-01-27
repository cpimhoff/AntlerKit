//
//  AgentProtocol.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/27/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import GameplayKit

/// Protocol that wraps (or is) a 2D agent
public protocol AgentProtocol {
	
	var agent : GKAgent2D { get }
	
}

extension GKAgent2D : AgentProtocol {
	
	public var agent : GKAgent2D {
		return self
	}
	
}

extension GameObject : AgentProtocol {
	// internal stored property on GameObject
}
