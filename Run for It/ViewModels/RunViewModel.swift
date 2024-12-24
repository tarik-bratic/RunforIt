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

class RunViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var distance: String = "0.00 km"
    @Published var speed: String = "0:00" //tempo i formatet min/km
    @Published var duration: String = "00:00" //tiden i formatet mm/ss
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var locationAccessDenied: Bool = false
    
    private var locationManager: CLLocationManager?
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0.0
    private var totalDistancee: Double = 0.0
    private var isPaused = false
    
    override init() {
            super.init()
            configureLocationManager()
        }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }
    
    func checkIfLocationServicesEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            } else {
                print("Location services are disabled. Please enable them.")
            }
        }
    
    private func checkLocationAuthorization() {
            guard let locationManager else { return }

            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                locationAccessDenied = true
            case .authorizedAlways, .authorizedWhenInUse:
                locationAccessDenied = false
            @unknown default:
                break
            }
        }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    
    func startRun() {
        if isPaused {
            isPaused = false
            startTimer()
            locationManager?.startUpdatingLocation()
        } else {
            resetRun()
            locationManager?.startUpdatingLocation()
            startTimer()
        }
    }
    
    func pauseRun() {
        isPaused = true
        stopTimer()
        locationManager?.stopUpdatingLocation()
    }
    
    func stopRun() {
        locationManager?.stopUpdatingLocation()
        stopTimer()
        isPaused = false
    }
    
    private func resetRun() {
        routeCoordinates = []
        totalDistancee = 0.0
        elapsedTime = 0.0
        distance = "0.00 km"
        speed = "0:00"
        duration = "00:00"
    }
    
    private func updateLocation(_ location: CLLocation) {
        DispatchQueue.main.async {
            if let lastCoordinates = self.routeCoordinates.last {
                let lastLocation = CLLocation(latitude: lastCoordinates.latitude, longitude: lastCoordinates.longitude)
                let distanceDelta = location.distance(from: lastLocation)
                
                if distanceDelta > 1 {
                    self.totalDistancee += distanceDelta
                    self.distance = String(format: "%.2f km", self.totalDistancee / 1000)
                    self.updateSpeed()
                }
            }
            
            self.routeCoordinates.append(location.coordinate)
            self.region.center = location.coordinate
        }
    }
    
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
            self.updateDuration()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateDuration() {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        self.duration = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateSpeed() {
        guard totalDistancee > 0, elapsedTime > 0 else {
            self.speed = "0:00"
            return
        }
        
        let paceInSeconds = elapsedTime / (totalDistancee / 1000)
        let minutes = Int(paceInSeconds) / 60
        let seconds = Int(paceInSeconds) % 60
        self.speed = String(format: "%d:%02d", minutes, seconds)
    }
    
}
