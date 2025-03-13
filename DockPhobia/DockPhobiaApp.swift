//
//  DockPhobiaApp.swift
//  DockPhobia
//
//  Created by neon443 on 13/03/2025.
//

import SwiftUI

@main
struct DockPhobiaApp: App {
	var body: some Scene {
		MenuBarExtra(
			"Menu Bar",
			systemImage: "star"
		) {
			ContentView()
				.overlay(alignment: .topLeading) {
					Button() {
						NSApp.terminate(nil)
					} label: {
						Image(systemName: "xmark.circle.fill")
							.foregroundStyle(.blue)
					}
					.buttonStyle(PlainButtonStyle())
				}
				.frame(width: 300, height: 180)
		}
		.menuBarExtraStyle(.window)
	}
}
//struct DockPhobiaApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
