//
//  RunningStatView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-14.
//

import SwiftUI

struct RunningStatView: View {
    @ObservedObject var viewModel = RunViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isPaused = false
    @State private var selectedTab: Int = 1
        
    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack {
                // Map / Trail View
                CustomMapView(
                    routeCoordinates: $viewModel.routeCoordinates,
                    region: $viewModel.region
                )
                
                // Slider Container
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(white: 1, opacity: 0.5))
                    .overlay(
                        Text("slide to  return")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                    )
                    .shadow(radius: 10)
                    .offset(x: 0, y: 320)
                    .frame(width: 350, height: 75)
            }
            .ignoresSafeArea()
            .tag(0)
            
            VStack() {
                // Duration Container
                VStack(spacing: 5) {
                    Text(viewModel.duration)
                        .font(.system(size: 48, weight: .bold))
                    Text("TID")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                
                Divider()
                
                // Distance Container
                VStack(spacing: 5) {
                    Text(viewModel.distance)
                        .font(.system(size: 58, weight: .bold))
                    Text("KILOMETER")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: 175)
                
                Divider()
                
                // Tempo Container
                HStack {
                    // Current Temp Container
                    VStack(spacing: 10) {
                        Text(viewModel.speed)
                            .font(.system(size: 32, weight: .bold))
                        Text("AKTL. TEMPO")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 175, maxHeight: .infinity)
                    
                    Divider()
                    
                    // Avrage Tempo Container
                    VStack(spacing: 10) {
                        Text(viewModel.avrageSpeed)
                            .font(.system(size: 32, weight: .bold))
                        Text("MED. TEMPO")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 175, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: 125)
                
                // Button Container
                HStack(spacing: 30) {
                    // Pause / Resume Button
                    Button(action: {
                        isPaused.toggle()
                        
                        if isPaused {
                            viewModel.pauseRun()
                        } else {
                            viewModel.startRun()
                        }
                    }) {
                        Image(systemName: isPaused ? "play.circle": "pause.circle.fill")
                            .foregroundStyle(.yellow)
                            .font(.system(size: 72))
                            .symbolRenderingMode(.hierarchical)
                            .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.wholeSymbol), options: .nonRepeating))
                    }
                    
                    // Stop Button
                    Button(action: {
                        viewModel.stopRun()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "stop.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 72))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 125)
            }
            .ignoresSafeArea()
            .tag(1)
        }
        .ignoresSafeArea()
        .tabViewStyle( PageTabViewStyle() )
    }
}

#Preview {
    RunningStatView()
}
