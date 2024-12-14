//
//  ContentView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Start Running", destination: RunningMapView())
            }
            .navigationTitle("Run for It")
        }
    }
}

#Preview {
    ContentView()
}
