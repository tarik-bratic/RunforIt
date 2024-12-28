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
            VStack(spacing: 150) {
                Text("Run for It")
                    .font(.system(size: 56, weight: .bold))
                    .frame(width: 110, height: 300)
                    .italic()
                
                Button(action: {
                    showRunView = true
                    viewModel.startRun()
                }) {
                    RoundedRectangle(cornerRadius: 30)
                        .overlay(
                            Text("Start Run")
                                .foregroundColor(.white)
                        )
                        .frame(width: 200, height: 50)
                }
                .fullScreenCover(isPresented: $showRunView) {
                    RunView(viewModel: viewModel)
                }
            }
            .tabItem {
                Label("Run", systemImage: "play.circle")
            }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
