//
//  LocationManager.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import Foundation
import CoreLocation

/// LocationManager handles location updates and communicates them via a closure.
class LocationManager: NSObject, ObservableObject {
    // Array of route coordinates for tracking purposes
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    // CoreLocation manager instance
    private let locationManager = CLLocationManager()
    // Closure to notify when a location update occurs
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    /// Configures the location manager with desired settings
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization() // Request location access
    }
    
    /// Starts location tracking and clears previous route coordinates
    func startTracking() {
        routeCoordinates = []
        locationManager.startUpdatingLocation()
    }
    
    /// Stops location tracking
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    /// Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        routeCoordinates.append(newLocation.coordinate)
        onLocationUpdate?(newLocation)
    }
    
    /// Handles changes in location authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = manager.location {
                onLocationUpdate?(location)
            }
        case .denied, .restricted:
            print("Location access: Denieed or restricted")
        case .notDetermined:
            print("Location access: Not determined")
        @unknown default:
            print("Location access: Unknown state")
        }
    }
    
}
