//
//  HomeView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-13.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = RunViewModel()
    
    var body: some View {
        TabView {
            VStack {
                Text("Run for It")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                
                CustomMapView(
                    routeCoordinates: $viewModel.routeCoordinates,
                    region: $viewModel.region
                )
                .frame(height: 500)
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    viewModel.stopRun()
                }) {
                    Text("Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 350, height: 50)
                        .background(Color.green)
                        .cornerRadius(50)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .tabItem {
                Label("Start", systemImage: "play.circle")
            }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

#Preview {
    HomeView()
}
