//
//  RunViewModel.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

class RunViewModel: ObservableObject {
    @Published var distance: String = "0.0 m"
    @Published var speed: String = "0.0 m/s"
    @Published var duration: String = "0 s"
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7127, longitude: -73.998),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private var locationManager = LocationManager()
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0.0
    
    func startRun() {
        locationManager.startTracking { [weak self] location in
            self?.updateLocation(location)
        }
        startTimer()
    }
    
    func stopRun() {
        locationManager.stopTracking()
        stopTimer()
    }
    
    private func updateLocation(_ location: CLLocation) {
        DispatchQueue.main.async {
            self.routeCoordinates.append(location.coordinate)
            self.region.center = location.coordinate
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
            self.updateStats()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateStats() {
        DispatchQueue.main.async {
            self.distance = String(format: "%.2f m", self.locationManager.distance)
            self.speed = String(format: "%.2f m/s", self.locationManager.speed)
            self.duration = "\(Int(self.elapsedTime)) s"
        }
    }
}
