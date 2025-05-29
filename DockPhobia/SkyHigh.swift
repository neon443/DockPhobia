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
			contentRect: settings.settings.mouseMoveRect,
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		window.backgroundColor = .init(srgbRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.05)
		window.isOpaque = false
		window.level = NSWindow.Level.statusBar + 1
		window.ignoresMouseEvents = true
		window.hasShadow = true
		window.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces.union(.stationary)
		window.makeKeyAndOrderFront(nil)
	}
	
	func move() {
		x = 5
		timer?.invalidate()
		timer = Timer(timeInterval: 0.01, repeats: true) { [weak self] _ in
			guard let self = self else { return }
			guard x < 1001 else {
				timer?.invalidate()
				return
			}
			self.window.setFrameOrigin(NSPoint(x: 1000-self.x, y: 1000-self.x))
			self.x += 5
		}
		RunLoop.current.add(timer!, forMode: .common)
	}
}
