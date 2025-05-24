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
			button.image = NSImage(named: "cursor")
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
		let one = NSMenuItem(title: "hi", action: #selector(didTapStart), keyEquivalent: "s s")
		menu.addItem(one)
		
		menu.addItem(NSMenuItem.separator())
		statusItem.menu = menu
	}
	
	func changeMenuIcon(running: Bool) {
		if let button = statusItem.button {
			button.image = NSImage(named: "cursor\(running ? ".motion" : "")")
		}
	}
	
	@objc func didTapStart() {
		if mouseTracker.running {
			mouseTracker.removeMonitor()
			changeMenuIcon(running: false)
		} else {
			mouseTracker.addMonitor()
			changeMenuIcon(running: true)
		}
	}
}
