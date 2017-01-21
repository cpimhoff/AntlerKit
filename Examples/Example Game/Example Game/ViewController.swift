//
//  ViewController.swift
//  Example Game
//
//  Created by Charlie Imhoff on 12/31/16.
//  Copyright © 2016 Charlie Imhoff. All rights reserved.
//

import Cocoa
import AntlerKit

class ViewController: NSViewController {

    @IBOutlet var akView: AntlerKitView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let view = self.akView {
			let s = GameScene(size: view.bounds.size)
			view.begin(with: s)
		}
    }
}

