//
//  AntlerGameView.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

open class AntlerKitView : UIView, AntlerKitViewProtocol {
	
	open var renderingView : SKView
	
	override public init(frame: CGRect) {
		let bounds = CGRect(origin: Point.zero, size: frame.size)
		self.renderingView = SKView(frame: bounds)
		
		super.init(frame: frame)
		
		self.autoresizesSubviews = true
		renderingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		self.addSubview(renderingView)
	}
	
	convenience public init() {
		self.init(frame: .zero)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
