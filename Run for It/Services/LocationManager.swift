//
//  LocationManager.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import Foundation
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject {
    var onLocationUpdate: ((CLLocation) -> Void)?
    private let locationManager = CLLocationManager()
    private let delegateProxy = CLLocationManagerDelegateProxy()
    
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = delegateProxy
        delegateProxy.onLocationUpdate = { [weak self] location in
            guard let self else { return }
            self.routeCoordinates.append(location.coordinate)
            self.onLocationUpdate?(location)
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }
    
    func startTracking() {
        routeCoordinates = []
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}

/// A proxy class to handle CLLocationManagerDelegate callbacks
private class CLLocationManagerDelegateProxy: NSObject, CLLocationManagerDelegate {
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        onLocationUpdate?(newLocation)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Location access: Always authorized")
        case .authorizedWhenInUse:
            print("Location access: Authorized when in use")
        case .denied, .restricted:
            print("Location access: Denied or restricted")
        case .notDetermined:
            print("Location access: Not determined")
        @unknown default:
            print("Location access: Unknown state")
        }
    }
}
