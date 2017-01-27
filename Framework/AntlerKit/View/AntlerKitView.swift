//
//  AntlerGameViewProtocol.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

public class AntlerKitView : SKView {
	
	public init(firstScene: Scene, frame: Rect) {
		super.init(frame: frame)
		Scene.stack.swapEntire(toNewBase: firstScene, on: self)
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	public func begin(with firstScene: Scene) {
		Scene.stack.swapEntire(toNewBase: firstScene, on: self)
		self.becomeFirstResponder()
	}
	
}
