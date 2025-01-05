//
//  HomeView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-13.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = RunViewModel()
    @State private var showRunView = false
    
    var body: some View {
        TabView() {
            // Run tab
            RunTab(viewModel: viewModel, showRunView: $showRunView)
                .tabItem {
                    Label("Run", systemImage: "play.circle")
                }
            
            // History tab
            HistoryView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Previously", systemImage: "clock")
                }
        }
        .ignoresSafeArea()
    }
}

/// A reuseable component for the "Run" tab
struct RunTab: View {
    @ObservedObject var viewModel: RunViewModel
    @Binding var showRunView: Bool
    
    var body: some View {
        VStack(spacing: 150) {
            // App title
            Text("Run for It")
                .font(.system(size: 56, weight: .bold))
                .frame(width: 110, height: 300)
                .italic()
            
            // Start Run Button
            Button(action: startRun) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.blue)
                    .frame(width: 200, height: 50)
                    .overlay(
                        Text("Start Run")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
            }
            .fullScreenCover(isPresented: $showRunView) {
                RunView(viewModel: viewModel)
            }
        }
        .padding()
    }
    
    /// Starts the run and shows the 'RunView'
    private func startRun() {
        showRunView = true
        viewModel.startRun()
    }
}

#Preview {
    HomeView()
}
