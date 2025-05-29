//
//  SkyHigh.swift
//  DockPhobia
//
//  Created by neon443 on 28/05/2025.
//

import Foundation
import Cocoa

class SkyHigh {
	private var window: NSWindow
	private var x = 1
	private var timer: Timer?
	var settings: DPSettingsModel
	
	init(settings: DPSettingsModel) {
		self.settings = settings
		
		self.window = NSWindow(
			contentRect: CGRect(
				x: NSScreen.mainFrameWidth/2,
				y: NSScreen.mainFrameHeight/2,
				width: 50,
				height: 50
			),
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		window.backgroundColor = .init(srgbRed: 1, green: 1, blue: 1, alpha: 0.2)
		window.isOpaque = false
		window.level = NSWindow.Level.statusBar + 1
		window.ignoresMouseEvents = true
		window.hasShadow = true
		window.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces.union(.stationary)
		window.makeKeyAndOrderFront(nil)
	}
	
	func move(to: CGPoint) {
		self.window.setFrameOrigin(to)
	}
}
