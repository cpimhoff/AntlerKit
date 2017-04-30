//
//  AnimationState.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/23/17.
//

import Foundation
import SpriteKit

#if os(iOS)
	private typealias Image = UIImage
#elseif os(macOS)
	private typealias Image = NSImage
#endif

//
//	Animation Naming Format
//	"sheet animation 0"
//

open class Animation {
	
	public var frames : [SKTexture]
	
	public init(frames: [SKTexture]) {
		self.frames = frames
	}
	
	public convenience init?(sheetName: String, animationName: String) {
		var frameList = [SKTexture]()
		
		var frameNumber = 0
		while true {
			let frameName = "\(sheetName) \(animationName) \(frameNumber)"
			
			guard let image = Image(named: frameName) else { break }
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
