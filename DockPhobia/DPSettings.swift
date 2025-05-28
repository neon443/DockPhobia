//
//  Persistence.swift
//  DockPhobia
//
//  Created by neon443 on 27/05/2025.
//

import Foundation
import AppKit

struct DPSettings: Codable {
	var dockMoves: Int = 0
	var checkFullscreen: Bool = false
	var moveMouseInstead: Bool = false
}

class DPSettingsModel {
	var settings = DPSettings()
	
	let userDefaults = UserDefaults.standard
	
	init() {
		guard let data = userDefaults.data(forKey: "settings") else { return }
		
		let decoder = JSONDecoder()
		
		guard let decoded = try? decoder.decode(DPSettings.self, from: data) else {
			return
		}
		self.settings = decoded
		refreshMenus()
	}
	
	func saveSettings() {
		let encoder = JSONEncoder()
		guard let encoded = try? encoder.encode(settings) else {
			return
		}
		userDefaults.set(encoded, forKey: "settings")
	}
}
