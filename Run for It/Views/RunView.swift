//
//  RunView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-14.
//

import SwiftUI
import MapKit

struct RunView: View {
    @ObservedObject var viewModel = RunViewModel()
    @Environment(\.presentationMode) var presentationMode
        
    @State private var isPaused = false
    @State private var selectedTab: Int = 1
    
    @State private var mapView: MKMapView? = nil
        
    var body: some View {
        TabView(selection: $selectedTab) {
            // Map Container
            ZStack {
                // Map / Trail View
                MapView(
                    routeCoordinates: $viewModel.routeCoordinates,
                    region: $viewModel.region,
                    onMapViewCreated: { map in
                        self.mapView = map
                    }
                )
                
                // Slider Container
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(white: 1, opacity: 0.4))
                    .overlay(
                        Text("swipe left to return")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    )
                    .offset(x: 0, y: 320)
                    .frame(width: 350, height: 65)
            }
            .ignoresSafeArea()
            .tag(0)
            
            // Stat Container
            VStack() {
                // Duration Container
                VStack(spacing: 5) {
                    Text(viewModel.duration)
                        .font(.system(size: 48, weight: .bold))
                    Text("TIME")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                
                Divider()
                
                // Distance Container
                VStack(spacing: 5) {
                    Text(viewModel.distance)
                        .font(.system(size: 58, weight: .bold))
                    Text("KILOMETERS")
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
                        Text("CURR. TEMPO")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 175, maxHeight: .infinity)
                    
                    Divider()
                    
                    // Avrage Tempo Container
                    VStack(spacing: 10) {
                        Text(viewModel.avrageSpeed)
                            .font(.system(size: 32, weight: .bold))
                        Text("AVG. TEMPO")
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
                        if let map = mapView {
                            viewModel.stopRun(mapView: map)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "stop.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 72))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 125)
                
                // Text Container
                ZStack {
                    Text("swipe right for map")
                        .font(.title3)
                        .fontWeight(.bold)
                        .opacity(0.3)
                }
            }
            .ignoresSafeArea()
            .tag(1)
        }
        .ignoresSafeArea()
        .tabViewStyle( PageTabViewStyle() )
    }
}

#Preview {
    RunView()
}
