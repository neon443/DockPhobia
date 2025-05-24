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

enum DockSide {
	case left
	case right
	case bottom
}

class MouseTracker {
	var screen: Screen
	
	var monitor: Any?
	
	var running: Bool = false
	
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
		moveDock(.left)
		moveDock(.bottom)
	}
	
	func checkMouse(_ event: NSEvent) {
		var location = event.locationInWindow
		location.y = screen.height - location.y
		#if DEBUG
		print(location)
		#endif
		if location.y > 1000 {
			
		}
	}
	
	func addMonitor() {
		self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler: checkMouse)
		self.running = true
		print("started tracking")
	}
	
	func removeMonitor() {
		if let monitor = monitor {
			NSEvent.removeMonitor(monitor)
			self.running = false
		}
		
		print("stop tracking")
	}
	
	func moveDock(_ toSide: DockSide) {
		let script = """
  tell application "System Events"
   tell dock preferences
    set screen edge to \(toSide)
   end tell
  end tell
  """
		applescript(script)
	}
	
	func applescript(_ script: String) {
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
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
