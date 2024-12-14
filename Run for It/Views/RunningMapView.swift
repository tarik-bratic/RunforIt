//
//  RunningMapView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import SwiftUI
import MapKit

struct RunningMapView: View {
    @StateObject var viewModel = RunViewModel()
    
    var body: some View {
        VStack {
            CustomMapView(
                routeCoordinates: $viewModel.routeCoordinates,
                region: $viewModel.region
            )
            .edgesIgnoringSafeArea(.all)
            
            HStack {
                Text("Distance: \(viewModel.distance)")
                Text("Speed: \(viewModel.speed)")
                Text("Duration: \(viewModel.duration)")
            }
            .padding()
            Button("Stop Run") {
                viewModel.stopRun()
            }
        }
        .onAppear {
            viewModel.startRun()
        }
    }
}
