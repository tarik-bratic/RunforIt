//
//  MapView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var region: MKCoordinateRegion
    
    var onMapViewCreated: ((MKMapView) -> Void)?

    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
    }

    // MARK: - UIViewRepresentable
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        onMapViewCreated?(mapView) // Provide the MKMapView instance to the parent
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateMapViewRegion(mapView)
        updateMapViewOverlay(mapView)
    }
    
    func dismantleUIView(_ mapView: MKMapView, coordinator: Coordinator) {
        mapView.delegate = nil // Avoid memory leaks
    }
}

private extension MapView {
    // MARK: - Helper Methods
    
    /// Updates the map view's region
    func updateMapViewRegion(_ mapView: MKMapView) {
        mapView.setRegion(region, animated: true)
    }
    
    /// Updates the map view's overlays based on routeCoordinates
    func updateMapViewOverlay(_ mapView: MKMapView) {
        // Clears existing overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Add a new polyline overlay if there are enough coordinates
        guard routeCoordinates.count > 1 else { return }
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        mapView.addOverlay(polyline)
    }
}
