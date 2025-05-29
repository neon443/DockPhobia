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
	
	init() {
		guard let screen = NSScreen.main?.frame else { fatalError() }
		self.window = NSWindow(
			contentRect: CGRect(
				x: screen.width*0.05,
				y: screen.height*0.1,
				width: screen.width*0.9,
				height: screen.height*0.8
			),
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		window.backgroundColor = .init(srgbRed: 1, green: 1, blue: 1, alpha: 0.1)
		window.isOpaque = false
		window.level = NSWindow.Level.statusBar + 1
		window.ignoresMouseEvents = true
		window.hasShadow = true
		window.makeKeyAndOrderFront(nil)
		window.setFrameOrigin(NSPoint(x: screen.width*0.05, y: screen.height*0.1))
	}
	
	func move() {
		x = 1
		timer?.invalidate()
		timer = Timer(timeInterval: 0.01, repeats: true) { [weak self] _ in
			guard let self = self else { return }
			guard x < 1001 else {
				timer?.invalidate()
				return
			}
			self.window.setFrameOrigin(NSPoint(x: 1000-self.x, y: 1000-self.x))
			self.x += 1
		}
		RunLoop.current.add(timer!, forMode: .common)
	}
}
