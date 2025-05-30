//
//  AppDelegate.swift
//  DockPhobia
//
//  Created by neon443 on 23/05/2025.
//

import AppKit
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	public var statusItem: NSStatusItem!
	public var prefsWindow: NSWindowController?
	
	var settings = DPSettingsModel()
	var mouseTracker: MouseTracker
	let updateController: SPUStandardUpdaterController
	
	override init() {
		self.mouseTracker = MouseTracker(settings: settings)
		//call .startUpdater() later
		updateController = SPUStandardUpdaterController(
			startingUpdater: true,
			updaterDelegate: nil,
			userDriverDelegate: nil
		)
		super.init()
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		if let button = statusItem.button {
			button.image = NSImage(named: "cursor.slash")
		}
		refreshMenus()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		settings.saveSettings()
	}
	
	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
	
	//MARK: menu bar stuff
	func setupMenus() {
		let menu = NSMenu()
		let start = NSMenuItem(title: describeStartButton(), action: #selector(didTapStart), keyEquivalent: "")
		menu.addItem(start)
		
		let checkforUpdatesMenuItem = NSMenuItem(
			title: "Check for Updates...",
			action: #selector(SPUStandardUpdaterController.checkForUpdates(_:)),
			keyEquivalent: ""
		)
		checkforUpdatesMenuItem.target = updateController
		menu.addItem(checkforUpdatesMenuItem)
		
		let screen = NSMenuItem(
			title: "\(mouseTracker.screen.width)x\(mouseTracker.screen.height)",
			action: nil,
			keyEquivalent: ""
		)
		menu.addItem(screen)
		
		let dockMoves = NSMenuItem(
			title: "Moved the Dock \(settings.settings.dockMoves) time\(settings.settings.dockMoves.plural)",
			action: nil,
			keyEquivalent: ""
		)
		menu.addItem(dockMoves)
		
		let mouseMoves = NSMenuItem(
			title: "Moved the cursor \(settings.settings.mouseMoves) time\(settings.settings.mouseMoves.plural)",
			action: nil,
			keyEquivalent: ""
		)
		menu.addItem(mouseMoves)
		menu.addItem(NSMenuItem.separator())
		
		let moveMouseButton = NSMenuItem(
			title: "Move cursor instead",
			action: #selector(moveMouseToggle),
			keyEquivalent: ""
		)
		moveMouseButton.state = NSControl.StateValue(rawValue: settings.settings.moveMouseInstead ? 1 : 0)
		menu.addItem(moveMouseButton)
		
		menu.addItem(NSMenuItem.separator())
		
		let checkfullscreenButton = NSMenuItem(
			title: "Smaller deathzone in fullscreen",
			action: #selector(checkFullscreenToggle),
			keyEquivalent: ""
		)
		checkfullscreenButton.state = NSControl.StateValue(rawValue: settings.settings.checkFullscreen ? 1 : 0)
		menu.addItem(checkfullscreenButton)
		menu.addItem(NSMenuItem.separator())
		
		menu.addItem(NSMenuItem(
			title: "Move Dock to the left",
			action: #selector(moveDockObjcLeft),
			keyEquivalent: ""))
		menu.addItem(NSMenuItem(
			title: "Move Dock to the bottom",
			action: #selector(moveDockObjcBottom),
			keyEquivalent: ""))
		menu.addItem(NSMenuItem(
			title: "Move Dock to the right",
			action: #selector(moveDockObjcRight),
			keyEquivalent: ""))
		menu.addItem(NSMenuItem.separator())
		
		let prefs = NSMenuItem(
			title: "Preferences",
			action: #selector(tappedPrefs),
			keyEquivalent: ","
		)
		menu.addItem(prefs)
		
		let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
		menu.addItem(quit)
		statusItem.menu = menu
	}
	func changeMenuIcon(running: Bool) {
		guard let button = statusItem.button else { return }
		switch running {
		case true:
			button.image = NSImage(named: "cursor.motion")
		case false:
			button.image = NSImage(named: "cursor.slash")
		}
	}
	@objc func tappedPrefs() {
		if prefsWindow == nil {
			prefsWindow = DPPreferencesWindowController()
		}
		prefsWindow!.showWindow(nil)
		prefsWindow!.window?.orderFront(nil)
	}
	@objc func didTapStart() {
		if mouseTracker.running {
			mouseTracker.stop()
			changeMenuIcon(running: false)
		} else {
			mouseTracker.start()
			changeMenuIcon(running: true)
		}
		refreshMenus()
	}
	@objc func quit() {
		NSApplication.shared.terminate(self)
	}
	@objc func moveDockObjcLeft() { mouseTracker.moveDock(.left) }
	@objc func moveDockObjcRight() { mouseTracker.moveDock(.right) }
	@objc func moveDockObjcBottom() { mouseTracker.moveDock(.bottom) }
	@objc func checkFullscreenToggle() {
		settings.settings.checkFullscreen.toggle()
		refreshMenus()
	}
	@objc func moveMouseToggle() {
		settings.settings.moveMouseInstead.toggle()
		refreshMenus()
	}
	func describeStartButton() -> String {
		if mouseTracker.running {
			return "Stop tracking"
		} else {
			return "Start tracking"
		}
	}
}

func refreshMenus() {
	guard let delegate = NSApp.delegate as? AppDelegate else { return }
	delegate.setupMenus()
}

extension Numeric {
	var plural: String {
		return self == 1 ? "" : "s"
	}
}
