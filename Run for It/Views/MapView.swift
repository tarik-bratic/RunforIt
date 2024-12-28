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

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        DispatchQueue.main.async {
            mapView.setRegion(region, animated: true)
            
            // Remove overlays safely
            mapView.removeOverlays(mapView.overlays)
            
            // Avoid creating a polyline with less than 2 points
            guard self.routeCoordinates.count > 1 else { return }

            // Add polyline overlay
            let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
            mapView.addOverlay(polyline)
        }
    }
    
    func dismantleUIView(_ mapView: MKMapView, coordinator: Coordinator) {
        // Unset the delegate to prevent memory leaks
        mapView.delegate = nil
    }
}
