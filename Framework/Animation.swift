//
//  AnimationState.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/23/17.
//

import Foundation
import SpriteKit

public class Animation {
	
	public var frames : [SKTexture]
	
	public init(frames: [SKTexture]) {
		self.frames = frames
	}
	
	public convenience init() {
		self.init(frames: [SKTexture]())
	}
	
	public convenience init?(sheetName: String, animationName: String) {
		let baseName = sheetName + " " + animationName
		
		var frameList = [SKTexture]()
		
		var frameNumber = 0
		while true {
			let frameName = baseName + String(frameNumber)
			
			#if os(iOS)
				guard let image = UIImage(named: frameName) else { break }
			#elseif os(macOS)
				guard let image = NSImage(named: frameName) else { break }
			#endif
			let frame = SKTexture(image: image)
			
			frameList.append(frame)
			frameNumber += 1
		}
		
		if frameList.isEmpty {
			return nil
		}
		
		self.init(frames: frameList)
	}
	
}
