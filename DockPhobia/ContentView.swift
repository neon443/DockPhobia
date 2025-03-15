//
//  ContentView.swift
//  DockPhobia
//
//  Created by neon443 on 13/03/2025.
//

import SwiftUI

struct ContentView: View {
	@Binding var isTracking: Bool
	@State var mouseloc = NSEvent.mouseLocation
	
    var body: some View {
        VStack {
			Text("Screen size: \(getScreenSize())")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
			Spacer()
			Button("Start") {
				startTrackingMouse()
			}
			Button("Stop") {
				stopTrackingMouse()
			}
			Button() {
				NSApp.terminate(nil)
			} label: {
				Text("Quit")
			}
        }
        .padding()
    }
}

#Preview {
	ContentView(isTracking: .constant(true))
}
