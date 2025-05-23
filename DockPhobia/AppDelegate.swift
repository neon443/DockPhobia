//
//  AppDelegate.swift
//  DockPhobia
//
//  Created by neon443 on 23/05/2025.
//

import Cocoa
import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	@IBOutlet var window: NSWindow!
	
	var mouseTracker = MouseTracker()
	
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		mouseTracker.addMonitor()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}
