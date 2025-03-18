//
//  DockPhobiaApp.swift
//  DockPhobia
//
//  Created by neon443 on 13/03/2025.
//

import Foundation
import SwiftUI
import Cocoa
import CoreGraphics

//@main
//struct DockPhobiaApp: App {
//	@State var enabled: Bool = true
//	var body: some Scene {
//		WindowGroup {
//			ContentView(enabled: $enabled)
//		}
//		MenuBarExtra(
//			"Menu Bar",
//			systemImage: "cursorarrow\(enabled ? "" : ".slash")"
//		) {
//
//			Button("One") {
//				enabled.toggle()
//			}
//			.keyboardShortcut("1")
////			ContentView(enabled: $enabled)
////				.frame(width: 300, height: 200)
//		}
//		.menuBarExtraStyle(.window)
//	}
////	NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { event in
////		print("event:", event)
////	}
//
//}
////struct DockPhobiaApp: App {
////    var body: some Scene {
////        WindowGroup {
////            ContentView()
////        }
////    }
////}
import Foundation

@main
struct DockPhobiaApp: App {
	enum DockPosition: String {
		case left
		case right
		case bottom
	}
	
	@State var preferencesOpen: Bool = false
	@State var isTracking: Bool = false
	func toggleTracking() {
		if isTracking {
			stopTrackingMouse()
		} else {
			startTrackingMouse()
		}
		isTracking.toggle()
	}
	var body: some Scene {
		//		WindowGroup {
		//			ContentView(isTracking: $isTracking)
		//		}
		MenuBarExtra("Dock Phobia", systemImage: "cursorarrow\(isTracking ? "" : ".slash")") {
			Text(isTracking ? "Enabled" : "Disabled")
			Text("\(getScreenSize())")
			Button("Toggle tracking") {
				toggleTracking()
			}
			.keyboardShortcut(" ", modifiers: [])
			
			Divider()
			Button("Settings") {
				preferencesOpen.toggle()
			}
			.keyboardShortcut(",")
			Divider()
			Button("try shell") {
				print(shell("echo hello"))
			}
			Divider()
			Button("Move Dock to Right") {
				moveDock("right")
			}
			Divider()
			Button("Move Dock to Left") {
				moveDock("left")
			}
			Button("Move Dock to Bottom") {
				moveDock("bottom")
			}
			Button("Get Dock orientation") {
				print(getDockSide())
			}
			Button("Get Dock Height Percentage") {
				print(getDockHeightPercentage())
			}
			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}
			.keyboardShortcut("q")
		}
	}
}

func shell(_ command: String) -> (output: String?, error: String?) {
	let process = Process()
	let pipe = Pipe()
	let pipeError = Pipe()
	
	process.executableURL = URL(fileURLWithPath: "/bin/zsh")
	process.arguments = ["-c", command]
	process.standardOutput = pipe
	process.standardError = pipeError
	
	let outputHandle = pipe.fileHandleForReading
	let outputErrorHandle = pipeError.fileHandleForReading
	
	process.launch()
	process.waitUntilExit()
	
	let data = outputHandle.readDataToEndOfFile()
	let dataError = outputErrorHandle.readDataToEndOfFile()
	
	let output = String(
		data: data,
		encoding: .utf8
	)?.trimmingCharacters(in: .whitespacesAndNewlines)
	let outputError = String(
		data: dataError,
		encoding: .utf8
	)?.trimmingCharacters(in: .whitespacesAndNewlines)
	return (output: output, error: outputError)
}

func getDockSide() -> String {
	let result = shell("defaults read com.apple.Dock orientation")
	print("dock is on the \(result.output ?? "idk")")
	return result.output ?? "unknown"
}

// global event tap
var eventTap: CFMachPort?

func getDockHeightPercentage() -> Double {
	guard let screen = NSScreen.main else { return 0 }
	
	let fullHeight = screen.frame.height
	let visibleHeight = screen.visibleFrame.height
	
	let dockHeight = fullHeight - visibleHeight
	let percentage = (dockHeight / fullHeight) * 100
	
	return percentage
}

func startTrackingMouse() {
	let mask = CGEventMask(1 << CGEventType.mouseMoved.rawValue)
	let screenDimensions = getScreenSize()
	
	//try creating event tap
	eventTap = CGEvent.tapCreate(
		tap: .cgSessionEventTap,
		place: .headInsertEventTap,
		options: CGEventTapOptions.defaultTap,
		eventsOfInterest: mask,
		callback: { (proxy, type, event, userInfo) -> Unmanaged<CGEvent>? in
			let location = event.location
//			print("mouse at \(location)")
			//TODO: add Dock moving here
			return Unmanaged.passRetained(event)
		},
		userInfo: nil
	)
	
	//event tap started checking
	if let eventTap = eventTap {
		let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
		CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
		CGEvent.tapEnable(tap: eventTap, enable: true)
		
		print("    mouse tracking started!")
	} else {
		print("    failed to create event tap.")
	}
}


func stopTrackingMouse() {
	if let eventTap = eventTap {
		// disable event tap
		CGEvent.tapEnable(tap: eventTap, enable: false)
		
		// stops run loop
		CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue) {
			CFRunLoopStop(CFRunLoopGetMain())
		}
		
		print("    mouse tracking has stopped")
	} else {
		print("    no active event tap to stop")
	}
}

func getScreenSize() -> (x: CGFloat, y: CGFloat) {
	if let screen = NSScreen.main {
		let screenFrame = screen.frame
		let maxWidth = screenFrame.width
		let maxHeight = screenFrame.height
//		print("screen res: \(maxWidth)x\(maxHeight)")
		return (maxWidth, maxHeight)
	} else {
		print("you have no screen")
		print("what the fuck")
		return (-1.0, -1.0) //help me... i am not accounting for edge cases like this shit
	}
}

func moveDock(_ to: String) {
	print(NSApplication.shared.isAccessibilityEnabled())
	let validPositions = ["left", "right", "bottom"]
	guard validPositions.contains(to) else {
		print("Invalid Dock position: \(to)")
		return
	}
	
	let script = """
	tell application "System Events"
		tell dock preferences
			set screen edge to \(to)
		end tell
	end tell
	"""
	
	let process = Process()
	process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
	process.arguments = ["-e", script]
	
	do {
		try process.run()
		process.waitUntilExit()
		
		let status = process.terminationStatus
		if status == 0 {
			print("Dock moved to \(to)")
		} else {
			print("Failed to move dock, status: \(status)")
		}
	} catch {
		print("Error running AppleScript: \(error)")
	}
}
