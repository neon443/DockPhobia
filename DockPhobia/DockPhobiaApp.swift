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

func moveDock() {
	let process = Process()
	process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
	
	if let scriptPath = Bundle.main.path(forResource: "/Users/neon443/Documents/Xcode/DockPhobia/DockPhobia/script.scpt", ofType: "scpt") {
		process.arguments = [scriptPath]
		
		do {
			try process.run()
			process.waitUntilExit()
		} catch {
			print("error")
		}
	} else {
		print("error script not found")
	}
}

@main
struct DockPhobiaApp: App {
	enum DockPosition: String {
		case left
		case right
		case bottom
	}
	
	@State var enabled: Bool = true
	
	var body: some Scene {
		WindowGroup {
			ContentView(enabled: $enabled)
		}
		MenuBarExtra("Dock Phobia", systemImage: "cursorarrow\(enabled ? "" : ".slash")") {
			Toggle(enabled ? "Enabled" : "Disabled", isOn: $enabled)
			
			Divider()
			Button("Right") {
				moveDock()
			}
			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}
			.keyboardShortcut("q")
		}
	}
}

// global event tap
var eventTap: CFMachPort?

func startTrackingMouse() {
	let mask = CGEventMask(1 << CGEventType.mouseMoved.rawValue)
	
	//try creating event tap
	eventTap = CGEvent.tapCreate(
		tap: .cgSessionEventTap,
		place: .headInsertEventTap,
		options: CGEventTapOptions.defaultTap,
		eventsOfInterest: mask,
		callback: { (proxy, type, event, userInfo) -> Unmanaged<CGEvent>? in
			let location = event.location
			print("mouse at \(location)")
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
