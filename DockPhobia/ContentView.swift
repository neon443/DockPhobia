//
//  ContentView.swift
//  DockPhobia
//
//  Created by neon443 on 13/03/2025.
//

import SwiftUI

struct ContentView: View {
	@Binding var enabled: Bool
	@State var mouseloc = NSEvent.mouseLocation
    var body: some View {
        VStack {
			Text("\(NSEvent.mouseLocation)")
			Toggle("on", isOn: $enabled)
				.toggleStyle(SwitchToggleStyle())
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
			Spacer()
			Button("df") {
				startTrackingMouse()
			}
			Button("undf") {
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
	ContentView(enabled: .constant(true))
}
