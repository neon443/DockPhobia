//
//  Persistence.swift
//  DockPhobia
//
//  Created by neon443 on 27/05/2025.
//

import Foundation
import AppKit

extension NSScreen {
	static var mainFrame: CGRect {
		main?.frame ?? CGRect(x: 0, y: 0, width: 1920, height: 1080)
	}
	static var mainFrameWidth: CGFloat {
		main?.frame.width ?? 1920
	}
	static var mainFrameHeight: CGFloat {
		main?.frame.height ?? 1080
	}
}

struct DPSettings: Codable {
	var dockMoves: Int
	var mouseMoves: Int
	var checkFullscreen: Bool
	var moveMouseInstead: Bool
	
	var mouseInsetLeading: CGFloat {
		NSScreen.mainFrameWidth*insetHorizontal
	}
	var mouseInsetBottom: CGFloat {
		NSScreen.mainFrameHeight*insetVertical
	}
	var mouseInsetTop: CGFloat {
		NSScreen.mainFrameHeight*(1-(insetVertical))
	}
	var mouseInsetTrailing: CGFloat {
		NSScreen.mainFrameWidth*(1-(insetHorizontal))
	}
	
	var insetHorizontal: CGFloat
	var insetVertical: CGFloat
	
	var mouseMoveRect: CGRect {
		return CGRect(
			x: mouseInsetLeading,
			y: mouseInsetBottom,
			width: mouseInsetTrailing - mouseInsetLeading,
			height: mouseInsetTop - mouseInsetBottom
		)
	}
	
	init(
		dockMoves: Int = 0,
		mouseMoves: Int = 0,
		checkFullscreen: Bool = false,
		moveMouseInstead: Bool = false,
		insetHorizontal: CGFloat = 0.05,
		insetVertical: CGFloat = 0.1
	) {
		self.dockMoves = dockMoves
		self.mouseMoves = mouseMoves
		self.checkFullscreen = checkFullscreen
		self.moveMouseInstead = moveMouseInstead
		self.insetHorizontal = insetHorizontal
		self.insetVertical = insetVertical
	}
	
	init(from decoder: any Decoder) throws {
		let defaults = DPSettings()
		let container = try decoder.container(keyedBy: CodingKeys.self)
		dockMoves = try container.decodeIfPresent(Int.self, forKey: .dockMoves)
		?? defaults.dockMoves
		mouseMoves = try container.decodeIfPresent(Int.self, forKey: .mouseMoves)
		?? defaults.mouseMoves
		
		checkFullscreen = try container.decodeIfPresent(Bool.self, forKey: .checkFullscreen)
		?? defaults.checkFullscreen
		moveMouseInstead = try container.decodeIfPresent(Bool.self, forKey: .moveMouseInstead)
		?? defaults.moveMouseInstead
		
		insetHorizontal = try container.decodeIfPresent(CGFloat.self, forKey: .insetHorizontal)
		?? defaults.insetHorizontal
		insetVertical = try container.decodeIfPresent(CGFloat.self, forKey: .insetVertical)
		?? defaults.insetVertical
	}
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
