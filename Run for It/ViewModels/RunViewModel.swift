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
    
    @Published var locationAccessDenied: Bool = false
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
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
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled.")
            return
        }
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }

        DispatchQueue.main.async {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
                
            DispatchQueue.main.async {
                self.checkLocationAuthorization()
            }
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager else { return }
        
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            DispatchQueue.main.async {
                self.locationAccessDenied = true
                print("Your location is restricted likely due to parental control.")
            }
        case .denied:
            DispatchQueue.main.async {
                self.locationAccessDenied = true
                print("You have denied location services.")
            }
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self, let location = locationManager.location else { return }
                let region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                DispatchQueue.main.async {
                    self.region = region
                }
            }
        @unknown default:
            print("An unknown authorization status occurred.")
        }
    }
    
    func startRun() {
        if !isPaused {
            resetRun()
        }
        isPaused = false
        startTimer()
        locationManager?.startUpdatingLocation()
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
                    
                    print("Uppdaterad distans: \(self.distance)")
                }
            }

            self.routeCoordinates.append(location.coordinate)
            if self.region.center.latitude != location.coordinate.latitude ||
                self.region.center.longitude != location.coordinate.longitude {
                self.region.center = location.coordinate
            }
        }
    }
    
    private func startTimer() {
        stopTimer()
        
        self.totalDistancee = 0.0
        self.elapsedTime = 1.0
        
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
        
        print("IM HERE NOW")
        guard totalDistancee > 0, elapsedTime > 0 else {
            self.speed = "0:00"
            return
        }
        
        let paceInSeconds = elapsedTime / (totalDistancee / 1000)
        let minutes = Int(paceInSeconds) / 60
        let seconds = Int(paceInSeconds) % 60
        self.speed = String(format: "%d:%02d", minutes, seconds)
        
        print("Elapsed time: \(elapsedTime) sekunder")
            print("Total distans: \(totalDistancee) meter")
            print("Uppdaterat tempo: \(self.speed)")
    }
    
}
