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

extension NSEvent {
	var mouseLocationCG: CGPoint {
		var loc = NSEvent.mouseLocation
		loc.y = NSScreen.mainFrameHeight - loc.y
		return loc
	}
}

struct Screen {
	var width: CGFloat
	var height: CGFloat
}

class MouseTracker {
	var screen: Screen
	var monitor: Any?
	var running: Bool = false
	var currentDockSide: DockSide
	var dockHeight: CGFloat = 0
	
	var settings: DPSettingsModel
	var skyHigh: SkyHigh
	
	private var timer: Timer?
	private var loopIteration: Double = 0
	
	init(settings: DPSettingsModel) {
		print(DockSide())
		
		self.screen = Screen(
			width: NSScreen.mainFrameWidth,
			height: NSScreen.mainFrameHeight
		)
		print(self.screen)
		
		self.settings = settings
		self.skyHigh = SkyHigh(settings: settings)
		
		self.currentDockSide = .left
		moveDock(.bottom)
		getDockSize()
	}
	
	func checkMouse(_ event: NSEvent) {
		var location = NSEvent.mouseLocation
		location.y = screen.height - location.y
		
		guard settings.settings.checkFullscreen else {
			handleDockValue(dockIsAt: currentDockSide, location: location)
			return
		}
		
		guard isFrontmostFullscreen() else {
			if location.x < 1 ||
				location.x < screen.width-1 ||
				location.y > screen.height-1 {
				handleDockValue(dockIsAt: currentDockSide, location: location)
			}
			return
		}
	}
	
	func handleDockValue(dockIsAt: DockSide, location: NSPoint) {
		switch dockIsAt {
		case .left:
			guard location.x < dockHeight else { return }
			if location.y < screen.height/2 {
				moveDockOrMouse(.bottom)
				return
			} else {
				moveDockOrMouse(.right)
				return
			}
		case .bottom:
			guard location.y > screen.height - dockHeight else { return }
			if location.x < screen.width/2 {
				moveDockOrMouse(.right)
				return
			} else {
				moveDockOrMouse(.left)
				return
			}
		case .right:
			guard location.x > screen.width - dockHeight else { return }
			if location.y < screen.height/2 {
				moveDockOrMouse(.bottom)
				return
			} else {
				moveDockOrMouse(.left)
				return
			}
		}
	}
	
	func moveDockOrMouse(_ dockTo: DockSide) {
		if settings.settings.moveMouseInstead {
			moveMouse()
		} else {
			moveDock(dockTo)
		}
	}
	
	func start() {
		self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler: checkMouse)
		self.running = true
		print("started tracking")
		
		
		
		
		
		
		skyHigh.move()
		
		
		
		
		
		
		
		
		
		
		
	}
	
	func stop() {
		if let monitor = monitor {
			NSEvent.removeMonitor(monitor)
			self.running = false
		}
		
		print("stop tracking")
	}
	
	func moveMouse() {
		let prevPoint = NSEvent().mouseLocationCG
		let rangeW = settings.settings.mouseInsetLeading...settings.settings.mouseInsetTrailing
		let posX = CGFloat.random(in: rangeW)
		let rangeH = settings.settings.mouseInsetBottom...settings.settings.mouseInsetTop
		let posY = CGFloat.random(in: rangeH)
		print(prevPoint)
		print(posX, posY)
		
		timer?.invalidate()
		loopIteration = 0
		timer = Timer(timeInterval: 0.001, repeats: true) { [weak self] _ in
			guard let self = self else { return }
			guard NSEvent().mouseLocationCG != CGPoint(x: posX, y: posX) else {
				timer?.invalidate()
				return
			}
			guard loopIteration < 1000 else {
				timer?.invalidate()
				return
			}
			let newPosX = (prevPoint.x > posX ? prevPoint.x-loopIteration : prevPoint.x+loopIteration)
			let newPosY = (prevPoint.y > posY ? prevPoint.y-loopIteration : prevPoint.y+loopIteration)
			CGWarpMouseCursorPosition(CGPoint(x: newPosX, y: newPosY))
			
			self.loopIteration += 4
		}
		RunLoop.main.add(timer!, forMode: .common)
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
		settings.settings.dockMoves += 1
		refreshMenus()
	}
	
	func getDockSize() {
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
