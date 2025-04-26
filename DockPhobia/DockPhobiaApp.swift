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
				print(shell("echo hello") as Any)
			}
			Divider()
			Button("Move Dock to Right") {
				moveDock("right")
			}
			Button("Move Dock to Left") {
				moveDock("left")
			}
			Button("Move Dock to Bottom") {
				moveDock("bottom")
			}
			Divider()
			Button("Get Dock orientation") {
				print(getDockSide())
			}
			Button("Get Dock Height Percentage") {
				print(getDockHeight())
			}
			Divider()
			Button("calcdockFromBottom") {
				print(calcDockFromBottom())
			}
			Button("calc dock from right") {
				print(calcDockFromRight())
			}
			Button("calc dock from left") {
				print(calcDockFromLeft())
			}
			Divider()
			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}
			.keyboardShortcut("q")
		}
	}
}

func shell(_ command: String) -> String? {
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
	
	if outputError != "" {
		print(outputError as Any)
	}
	return output
}

func osascript(_ script: String) -> String? {
	let process = Process()
	let outputPipe = Pipe()
	let outputErrorPipe = Pipe()
	
	process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
	process.arguments = ["-e", script]
	process.standardOutput = outputPipe
	process.standardError = outputErrorPipe
	
	process.launch()
//	process.waitUntilExit()
		
	let outputHandle = outputPipe.fileHandleForReading.readDataToEndOfFile()
	let outputErrorHandle = outputErrorPipe.fileHandleForReading.readDataToEndOfFile()
	
	let outputData = String(
		data: outputHandle,
		encoding: .utf8
	)?
		.trimmingCharacters(
			in: .whitespacesAndNewlines
		)
	let outputErrorData = String(
		data: outputErrorHandle,
		encoding: .utf8
	)?
		.trimmingCharacters(
			in: .whitespacesAndNewlines
		)
	if outputErrorData != "" {
		print(outputErrorData as Any)
	}
	return outputData
}

func getDockSide() -> String {
	let result = shell("defaults read com.apple.Dock orientation")
	print("dock is on the \(result ?? "idk")")
	return result ?? "unknown"
}

// global event tap
var eventTap: CFMachPort?

func getDockHeight() -> Double {
	guard let screen = NSScreen.main else {
		return 0
	}
	
	let dockSide = getDockSide()
	let screenDimensions = getScreenSize()
	let width = screenDimensions.x
	let height = screenDimensions.y
	let visibleHeight = screen.visibleFrame.height
	
	let perpendicularToDock: CGFloat
	if dockSide == "bottom" {
		perpendicularToDock = height
	} else {
		perpendicularToDock = width
	}
	
	let dockHeight = CGFloat(height) - visibleHeight
	let percentage = (dockHeight / perpendicularToDock)
	return Double(percentage)
}

func calcDockFromBottom() -> CGFloat {
	let screenSize = getScreenSize()
	let dockHeight = getDockHeight()
	return screenSize.y - (screenSize.y * dockHeight)
}

func calcDockFromRight() -> CGFloat {
	let screenSize = getScreenSize()
	let dockHeight = getDockHeight()
	return screenSize.x - (screenSize.x * dockHeight)
}

func calcDockFromLeft() -> CGFloat {
	let screenSize = getScreenSize()
	let dockHeight = getDockHeight()
	return screenSize.x * dockHeight
}

func startTrackingMouse() {
	let mask = CGEventMask(1 << CGEventType.mouseMoved.rawValue)
	var dockSide = getDockSide()
	var lastMove = Date.now
	//try creating event tap
	eventTap = CGEvent.tapCreate(
		tap: .cgSessionEventTap,
		place: .headInsertEventTap,
		options: CGEventTapOptions.defaultTap,
		eventsOfInterest: mask,
		callback: { (proxy, type, event, userInfo) -> Unmanaged<CGEvent>? in
//			let location = event.location
//			print("mouse at \(location)")
//			print("mouse at \(event.location)")
			//TODO: add Dock moving here
			var lastDockMoveTime = Date()
			let debounceInterval: TimeInterval = 0.1
			if Date().timeIntervalSince(lastDockMoveTime) > debounceInterval {
				if event.location.y > 1000 {
					lastDockMoveTime = Date()
					Task {
						moveDock("left")
					}
				} else if event.location.x < 100 {
					lastDockMoveTime = Date()
					Task {
						moveDock("right")
					}
				} else if event.location.x > 1600 {
					lastDockMoveTime = Date()
					Task {
						moveDock("bottom")
					}
				}
			}
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
	let script = """
 tell application "Finder"
    get bounds of window of desktop
 end tell
 """
	let result = osascript(script)?.dropFirst(6).split(separator: ", ")
	// removes the "0, 0, " and splits into an arr
	let resultTuple = (
		CGFloat(
			Int(
				result![0]
			)!
		),
		CGFloat(
			Int(
				result![1]
			)!
		)
	)
	return resultTuple
}

func moveDock(_ to: String) {
//	let validPos = ["left", "bottom", "right"]
//	guard validPos.contains(to) else {
//		print("invalid dock position")
//		return
//	}
	let script = """
	tell application "System Events"
		tell dock preferences
			set screen edge to \(to)
		end tell
	end tell
	"""
	osascript(script)
	return
}
