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
	case bottom
	case right
	
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
	
	/// Random Dock Side
	/// - will return a random Dock Side when calling DockSide()
	public init() {
		self = DockSide(rawValue: Int.random(in: 1...3))!
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
	
	public init?(rawValue: Int) {
		switch rawValue {
		case 1:
			self = .left
		case 2:
			self = .bottom
		case 3:
			self = .right
		default:
			return nil
		}
	}
}

class MouseTracker {
	var screen: Screen
	
	var monitor: Any?
	
	var running: Bool = false
	
	var currentDockSide: DockSide
	
	init() {
		print(DockSide())
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
		self.currentDockSide = .left
		moveDock(.bottom)
		currentDockSide = .bottom
	}
	
	func checkMouse(_ event: NSEvent) {
		var location = event.locationInWindow
		location.y = screen.height - location.y
#if DEBUG
		print(location)
#endif
		
		switch currentDockSide {
		case .left:
			guard location.x < 100 else { return }
			if location.y < screen.height/2 {
				moveDock(.bottom)
				return
			} else {
				moveDock(.right)
				return
			}
		case .bottom:
			guard location.y > 1000 else { return }
			if location.x < screen.width/2 {
				moveDock(.right)
				return
			} else {
				moveDock(.left)
				return
			}
		case .right:
			guard location.x > 1600 else { return }
			if location.y < screen.height/2 {
				moveDock(.bottom)
				return
			} else {
				moveDock(.left)
				return
			}
		}
	}
	
	func start() {
		self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler: checkMouse)
		self.running = true
		print("started tracking")
	}
	
	func stop() {
		if let monitor = monitor {
			NSEvent.removeMonitor(monitor)
			self.running = false
		}
		
		print("stop tracking")
	}
	
	func moveDock(_ toSide: DockSide) {
		guard currentDockSide != toSide else { return }
//		let scriptHide = """
//  tell application "System Events" 
//    tell dock preferences
//      set autohide to true
//    end tell
//  end tell
//  """
//		
//		let scriptShow = scriptHide.replacingOccurrences(of: "true", with: "false")
		
		let scriptMove = """
  tell application "System Events"
   tell dock preferences
    set screen edge to \(toSide)
   end tell
  end tell
  """
//		applescript(scriptHide)
		applescript(scriptMove)
//		applescript(scriptShow)
		currentDockSide = toSide
	}
	
	@discardableResult
	func applescript(_ script: String) -> String? {
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
			if (error != nil) {
				print(error as Any)
			}
		}
		return nil
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
