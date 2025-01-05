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
            // Map Tab
            mapTab
                .ignoresSafeArea()
                .tag(0)
            
            // Stats Tab
            statsTab
                .ignoresSafeArea()
                .tag(1)
        }
        .tabViewStyle( PageTabViewStyle() )
        .ignoresSafeArea()
    }
}

private extension RunView {
    /// The Map Tap showing the map and a hint to swipe left
    var mapTab: some View {
        ZStack {
            MapView(
                routeCoordinates: $viewModel.routeCoordinates,
                region: $viewModel.region,
                onMapViewCreated: { map in
                    self.mapView = map
                }
            )
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(white: 1, opacity: 0.4))
                .overlay(
                    Text("swipe left to return")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(0.5)
                )
                .offset(y: 320)
                .frame(width: 350, height: 65)
        }
    }
    
    /// The Stats Tab showing run statistics and controls
    var statsTab: some View {
        VStack() {
            statSection(title: "TIME", value: viewModel.duration, fontSize: 48)
            
            Divider()
            
            // Distance Container
            statSection(title: "KILOMETERS", value: viewModel.distance, fontSize: 58)
            
            Divider()
            
            // Tempo Container
            HStack {
                statSection(title: "CURR. TEMPO", value: viewModel.speed, fontSize: 32)
                .frame(maxWidth: 175)
                
                Divider()
                
                statSection(title: "AVG. TEMPO", value: viewModel.averageSpeed, fontSize: 32)
                .frame(maxWidth: 175)
            }
            .frame(maxHeight: 125)
            
            buttonSection
            
            // Instruction text
            Text("swipe right for map")
                .font(.title3)
                .fontWeight(.bold)
                .opacity(0.3)
        }
        .padding()
    }
    
    /// A reuseable stat section for displaying run metrics
    func statSection(title: String, value: String, fontSize: CGFloat) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.system(size: fontSize, weight: .bold))
            Text(title)
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxHeight: 150)
    }
    
    /// The Button Section with Pause/Resume and Stop buttons
    var buttonSection: some View {
        HStack(spacing: 30) {
            Button(action: togglePauseResume) {
                Image(systemName: isPaused ? "play.circle": "pause.circle.fill")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 72))
                    .symbolRenderingMode(.hierarchical)
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.wholeSymbol), options: .nonRepeating))
            }
            
            Button(action: stopRun) {
                Image(systemName: "stop.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 72))
            }
        }
        .frame(maxHeight: 125)
    }
    
    /// Toggles the pause/resume state of the run
    func togglePauseResume() {
        isPaused.toggle()
        if isPaused {
            viewModel.pauseRun()
        } else {
            viewModel.startRun()
        }
    }
    
    /// Stops the run and dismisses the view
    func stopRun() {
        if let map = mapView {
            viewModel.stopRun(mapView: map)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    RunView(viewModel: RunViewModel())
}
