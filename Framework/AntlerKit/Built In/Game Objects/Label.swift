//
//  Label.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/23/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import SpriteKit

open class Label : GameObject {
	
	private var textNode : SKLabelNode! {
		get {
			return self.primitive as? SKLabelNode
		}
		set {
			self.primitive = newValue
		}
	}
	
	public init(text: String = "") {
		super.init()
		self.primitive = SKLabelNode(text: text)
	}
	
}

public extension Label {
	
	var text : String {
		get {
			return self.textNode.text ?? ""
		}
		set {
			self.textNode.text = newValue
		}
	}
	
	var fontSize : Float {
		get {
			return Float(self.textNode.fontSize)
		}
		set {
			self.textNode.fontSize = CGFloat(newValue)
		}
	}
	
	var fontName : String {
		get {
			return self.textNode.fontName!
		}
		set {
			self.textNode.fontName = newValue
		}
	}
	
}
