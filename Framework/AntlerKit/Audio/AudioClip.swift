//
//  AudioClip.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/30/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

/// Struct representing an Audio file stored as part of this bundle.
public struct AudioClip {
	
	public let fileName : String
	
	public init(fileNamed fileName: String) {
		self.fileName = fileName
	}
	
}
