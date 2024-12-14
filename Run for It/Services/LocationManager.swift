//
//  LocationManager.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var lastLocation: CLLocation?
    var onUpdate: ((CLLocation) -> Void)?
    
    @Published var distance: Double = 0.0
    @Published var speed: Double = 0.0
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func startTracking(onUpdate: @escaping (CLLocation) -> Void) {
        self.onUpdate = onUpdate
        manager.startUpdatingLocation()
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let newLocation = locations.last else { return }
            if let last = lastLocation {
                distance += newLocation.distance(from: last)
                speed = newLocation.speed > 0 ? newLocation.speed : 0.0
            }
            lastLocation = newLocation
            onUpdate?(newLocation)
        }
}
