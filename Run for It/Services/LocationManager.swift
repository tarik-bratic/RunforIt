//
//  LocationManager.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        routeCoordinates = []
        //self.onUpdate = onUpdate
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        onLocationUpdate?(newLocation)
        
        DispatchQueue.main.async {
            self.routeCoordinates.append(newLocation.coordinate)
        }
    }
}
