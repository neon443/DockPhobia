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
				width: 100,
				height: 100
			),
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		window.backgroundColor = .init(srgbRed: 1, green: 1, blue: 1, alpha: 0)
		window.contentView = NSImageView(image: NSImage(named: "pinch")!)
		window.isOpaque = false
		window.level = NSWindow.Level.statusBar + 1
		window.ignoresMouseEvents = true
		window.hasShadow = true
		window.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces.union(.stationary)
		#if DEBUG
		show()
		#endif
	}
	
	func move(to: CGPoint) {
		self.window.setFrameOrigin(to)
	}
	
	func show() {
		window.orderFront(nil)
	}
	
	func hide() {
		window.orderOut(nil)
	}
}
