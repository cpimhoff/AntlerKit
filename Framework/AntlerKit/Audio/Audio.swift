//
//  Audio.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 4/30/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

public struct Audio {
	
	#if os(iOS)
	/// Configures the application's audio session for game sounds and music.
	/// By default, the audio session is non-primary and mixable.
	public static func configureAudioSession() {
		let sessionType = AVAudioSessionCategoryAmbient
		try? AVAudioSession.sharedInstance().setCategory(sessionType)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	#endif
	
	private static var previousMix : AVAudioPlayer?
	private static var currentMix : AVAudioPlayer?
	
	/// Changes the currently playing music.
	/// Music plays independently of the scene.
	public static func changeMusic(to music: AudioClip, volume: Float = 1.0, mixTime: TimeInterval = 0) {
		self.changeMusic(toFileNamed: music.fileName, volume: volume, mixTime: mixTime)
	}
	
	/// Changes the currently playing music.
	/// Music plays independently of the scene.
	public static func changeMusic(toFileNamed fileName: String, volume: Float = 1.0, mixTime: TimeInterval = 0) {
		guard let musicURL = Bundle.main.url(forResource: fileName, withExtension: nil)
			else { return }
		guard let newMix = try? AVAudioPlayer(contentsOf: musicURL)
			else { return }
		
		// swap references
		previousMix = currentMix
		currentMix = newMix
		
		previousMix?.setVolume(0, fadeDuration: mixTime)
		
		// play new mix
		currentMix?.numberOfLoops = -1
		currentMix?.volume = 0
		
		currentMix?.prepareToPlay()
		currentMix?.play()
		
		currentMix?.setVolume(volume, fadeDuration: mixTime)
	}
	
	/// Plays an short Sound through the Scene
	public static func play(_ sound: AudioClip, volume: Float = 1.0) {
		self.play(soundFileNamed: sound.fileName, volume: volume)
	}
	
	/// Plays a short audio file through the Scene
	public static func play(soundFileNamed fileName: String, volume: Float = 1.0) {
		guard let root = Scene.current?.root else { return }
		
		let tempNode = SKNode()
		root.addChild(tempNode)
		
		let soundAction = SKAction.playSoundFileNamed(fileName, waitForCompletion: true)
		let removeAction = SKAction.removeFromParent()
		let sequence = SKAction.sequence([soundAction, removeAction])
		
		tempNode.run(sequence)
	}
	
}
