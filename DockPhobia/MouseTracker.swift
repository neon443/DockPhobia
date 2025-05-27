//
//  MouseTracker.swift
//  DockPhobia
//
//  Created by neon443 on 23/05/2025.
//

import Foundation
import AppKit
import Cocoa
import ApplicationServices

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
	
	var dockHeight: CGFloat = 0
	
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
		getDockSize()
	}
	
	func checkMouse(_ event: NSEvent) {
		var location = NSEvent.mouseLocation
		location.y = screen.height - location.y
		
		guard isFrontmostFullscreen() else {
			if location.x < 1 ||
				location.x < screen.width-1 ||
				location.y > screen.height-1 {
				handleDockValue(dockIsAt: currentDockSide, location: location)
			}
			return
		}
		
		handleDockValue(dockIsAt: currentDockSide, location: location)
	}
	
	func handleDockValue(dockIsAt: DockSide, location: NSPoint) {
		switch dockIsAt {
		case .left:
			guard location.x < dockHeight else { return }
			if location.y < screen.height/2 {
				moveDock(.bottom)
				return
			} else {
				moveDock(.right)
				return
			}
		case .bottom:
			guard location.y > screen.height - dockHeight else { return }
			if location.x < screen.width/2 {
				moveDock(.right)
				return
			} else {
				moveDock(.left)
				return
			}
		case .right:
			guard location.x > screen.width - dockHeight else { return }
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
	
	func getDockSize() {
		guard let screen = NSScreen.main?.frame else { fatalError() }
		guard let screenVisible = NSScreen.main?.visibleFrame else { fatalError() }
		self.dockHeight = screen.height - screenVisible.height
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

func isFrontmostFullscreen() -> Bool {
	guard let frontmostApp = NSWorkspace.shared.frontmostApplication,
		  let appPID = frontmostApp.processIdentifier as pid_t? else {
		return false
	}
	
	let appElement = AXUIElementCreateApplication(appPID)
	var frontWindo: AnyObject?
	let result = AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &frontWindo)
	
	guard result == .success, let windowElement = frontWindo else {
		return false
	}
	
	var fullscreenValue: AnyObject?
	let fullscreenAttr = AXUIElementCopyAttributeValue(windowElement as! AXUIElement, "AXFullScreen" as CFString, &fullscreenValue)
	
	if fullscreenAttr == .success,
	   let isFullscreen = fullscreenValue as? Bool {
		return isFullscreen
	}
	return false
}
