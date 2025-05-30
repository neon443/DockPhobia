//
//  Preferences.swift
//  DockPhobia
//
//  Created by neon443 on 29/05/2025.
//

import Foundation
import AppKit
import Sparkle

class DPPreferencesWindowController: NSWindowController {
	var mouseTracker: MouseTracker?
	var settings: DPSettingsModel?
	var updater: SPUStandardUpdaterController?
	
	@IBOutlet weak var mouseRadio: NSButton!
	@IBOutlet weak var dockRadio: NSButton!
	@IBOutlet weak var updateCheckButton: NSButton!
	@IBOutlet weak var smallDeathzoneToggle: NSButton!
	
	@IBOutlet weak var quitbutton: NSButton!
	
	override init(window: NSWindow?) {
		super.init(window: window)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	convenience init(mouseTracker: MouseTracker, settings: DPSettingsModel, updater: SPUStandardUpdaterController) {
		self.init(windowNibName: "Preferences")
		self.mouseTracker = mouseTracker
		self.settings = settings
		self.updater = updater
	}
	
	override func windowDidLoad() {
		smallDeathzoneToggle.state = NSControl.StateValue(
			settings!.settings.checkFullscreen ? 1 : 0
		)
		dockRadio.state = NSControl.StateValue(
			settings!.settings.moveMouseInstead ? 0 : 1
		)
		mouseRadio.state = NSControl.StateValue(
			settings!.settings.moveMouseInstead ? 1 : 0
		)
	}
	
	@IBAction func checkUpdates(_ sender: Any) {
		updater?.checkForUpdates(nil)
	}
	
	@IBAction func MoveTypeSelect(_ sender: Any) {
		if dockRadio.state.rawValue == 1 {
			settings?.settings.moveMouseInstead = false
		} else {
			settings?.settings.moveMouseInstead = true
		}
		refreshMenus()
	}
	
	@IBAction func quit(_ sender: Any) {
		NSApplication.shared.terminate(nil)
	}
	
	@IBAction func smallDeathzoneToggle(_ sender: Any) {
		settings?.settings.checkFullscreen.toggle()
	}
}
