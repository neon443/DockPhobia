//
//  ContentView.swift
//  DockPhobia
//
//  Created by neon443 on 13/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
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
    ContentView()
}
