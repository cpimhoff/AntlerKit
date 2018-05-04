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

/// Structure to hold information about a complete animation. An animation is a sequence of images (frames).
public struct Animation {
	
	public let frames : [SKTexture]
	
	public init(frames: [SKTexture]) {
		self.frames = frames
	}
	
	/// Load a sheet of animations from the assets bundle. Sheets must be named in the following manner:
	///
	/// ```sheetName-animationName-#```
	///
	/// The first frame of the animation is expected to be 0. The loader will continue fetching sequentially
	/// named frames until it can not find the next one.
	public init?(sheetName: String, animationName: String) {
		var frameList = [SKTexture]()
		
		var frameNumber = 0
		while true {
			let frameName = "\(sheetName)-\(animationName)-\(frameNumber)"
			
			#if os(iOS)
				guard let image = Image(named: frameName) else { break }
			#elseif os(macOS)
				guard let image = Image(named: Image.Name(rawValue: frameName)) else { break }
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
