//
//  MouseTracker.swift
//  DockPhobia
//
//  Created by neon443 on 23/05/2025.
//

import Foundation
import AppKit

struct Screen {
	var width: CGFloat
	var height: CGFloat
}

enum DockSide: Int, RawRepresentable {
	case left
	case right
	case bottom
	
	public typealias RawValue = String
	
	public var rawValue: RawValue {
		switch self {
		case .left:
			return "left"
		case .right:
			return "right"
		case .bottom:
			return "bottom"
		}
	}
	
	public init?(rawValue: String) {
		switch rawValue {
		case "left":
			self = .left
		case "right":
			self = .right
		case "bottom":
			self = .bottom
		default:
			return nil
		}
	}
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
	}
	
	func checkMouse(_ event: NSEvent) {
		var location = event.locationInWindow
		location.y = screen.height - location.y
		#if DEBUG
		print(location)
		#endif
		if location.y > 1000 {
			if location.x < screen.width/2 {
				moveDock(.right)
				return
			} else {
				moveDock(.left)
				return
			}
		}
		if location.x < 100 {
			if location.y < screen.height/2 {
				moveDock(.bottom)
				return
			} else {
				moveDock(.right)
				return
			}
		}
		if location.x > 1600 {
			if location.y < screen.height/2 {
				moveDock(.bottom)
				return
			} else {
				moveDock(.left)
				return
			}
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
