//
//  MouseTracker.swift
//  DockPhobia
//
//  Created by neon443 on 23/05/2025.
//

import Foundation
import AppKit
import Cocoa
import CoreGraphics

struct Screen {
	var width: CGFloat
	var height: CGFloat
}

class MouseTracker {
	var screen: Screen
	
	var monitor: NSEvent?
	
	init() {
		if let screen = NSScreen.main {
			let rect = screen.frame
			self.screen = Screen(
				width: rect.width,
				height: rect.height
			)
			print(self.screen)
		} else {
			fatalError("no screen wtf???")
		}
		addMonitor()
		applescript("display dialog \"dt\"")
	}
	
	func checkMouse(_ event: NSEvent) {
		var location = event.locationInWindow
		location.y = screen.height - location.y
		#if DEBUG
		print(location)
		#endif
	}
	
	func addMonitor() {
		self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler: checkMouse) as? NSEvent
	}
	
	func removeMonitor() {
		NSEvent.removeMonitor(monitor as Any)
	}
	
	func applescript(_ script: String) {
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
			print(output)
			if (error != nil) {
				print(error as Any)
			}
		}
	}
}


/*- (void) startEventTap {
	//eventTap is an ivar on this class of type CFMachPortRef
	eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionListenOnly, kCGEventMaskForAllEvents, myCGEventCallback, NULL);
	CGEventTapEnable(eventTap, true);
}

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	if (type == kCGEventMouseMoved) {
		NSLog(@"%@", NSStringFromPoint([NSEvent mouseLocation]));
	}
	
	return event;
}
*/
