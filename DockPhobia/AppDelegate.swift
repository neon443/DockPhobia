//
//  AppDelegate.swift
//  DockPhobia
//
//  Created by neon443 on 23/05/2025.
//

import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	public var statusItem: NSStatusItem!
	
	var mouseTracker = MouseTracker()
	
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		if let button = statusItem.button {
			button.image = NSImage(named: "cursor.slash")
		}
		setupMenus()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
	
	func setupMenus() {
		let menu = NSMenu()
		let start = NSMenuItem(title: describeStartButton(), action: #selector(didTapStart), keyEquivalent: "")
		menu.addItem(start)
		
		let screen = NSMenuItem(
			title: "\(mouseTracker.screen.width)x\(mouseTracker.screen.height)",
			action: nil,
			keyEquivalent: ""
		)
		menu.addItem(screen)
		
		menu.addItem(NSMenuItem.separator())
		
		menu.addItem(
			NSMenuItem(
				title: "Move Dock to left",
				action: #selector(moveDockObjcLeft),
				keyEquivalent: ""
			)
		)
		menu.addItem(
			NSMenuItem(
				title: "Move Dock to bottom",
				action: #selector(moveDockObjcBottom),
				keyEquivalent: ""
			)
		)
		menu.addItem(
			NSMenuItem(
				title: "Move Dock to right",
				action: #selector(moveDockObjcRight),
				keyEquivalent: ""
			)
		)
		
		menu.addItem(NSMenuItem.separator())
		
		let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
		menu.addItem(quit)
		statusItem.menu = menu
	}
	
	func changeMenuIcon(running: Bool) {
		guard let button = statusItem.button else { return }
		switch running {
		case true:
			button.image = NSImage(named: "cursor.motion")
		case false:
			button.image = NSImage(named: "cursor.slash")
		}
	}
	
	@objc func didTapStart() {
		if mouseTracker.running {
			mouseTracker.stop()
			changeMenuIcon(running: false)
		} else {
			mouseTracker.start()
			changeMenuIcon(running: true)
		}
		setupMenus()
	}
	
	@objc func quit() {
		NSApplication.shared.terminate(self)
	}
	
	@objc func moveDockObjcLeft() { mouseTracker.moveDock(.left) }
	@objc func moveDockObjcRight() { mouseTracker.moveDock(.right) }
	@objc func moveDockObjcBottom() { mouseTracker.moveDock(.bottom) }
	
	func describeStartButton() -> String {
		if mouseTracker.running {
			return "Stop tracking"
		} else {
			return "Start tracking"
		}
	}
}
