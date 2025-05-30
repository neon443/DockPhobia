//
//  Preferences.swift
//  DockPhobia
//
//  Created by neon443 on 29/05/2025.
//

import Foundation
import AppKit
import Sparkle

class DPPreferencesWindowController: NSWindowController {
	@IBOutlet weak var updateCheckButton: NSButton!
	
	override init(window: NSWindow?) {
		super.init(window: window)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	convenience init() {
		self.init(windowNibName: "Preferences")
	}
}
