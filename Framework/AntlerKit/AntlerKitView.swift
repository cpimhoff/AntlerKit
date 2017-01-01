//
//  AntlerGameViewProtocol.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

public protocol AntlerKitViewProtocol : AnyObject {
	
	var renderingView : SKView { get }
	
	var currentScene : Scene? { get set }
	
}

extension AntlerKitViewProtocol {
	
	public func present(_ nextScene: Scene, with transition: SKTransition? = nil) {
		if transition != nil {
			renderingView.presentScene(nextScene.root, transition: transition!)
		} else {
			renderingView.presentScene(nextScene.root)
		}
		
		self.currentScene = nextScene
	}
	
}