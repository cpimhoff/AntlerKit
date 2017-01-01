//
//  AntlerGameViewProtocol.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

internal protocol AntlerKitViewProtocol {
	
	var renderingView : SKView { get }
	
}

extension AntlerKitViewProtocol {
	
	public func present(_ nextScene: Scene, with transition: SKTransition? = nil) {
		
	}
	
}
