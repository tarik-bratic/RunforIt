//
//  MapView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: RunViewModel

    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .ignoresSafeArea()
            .onAppear {
                viewModel.checkIfLocationServicesEnabled()
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: RunViewModel())
    }
}
