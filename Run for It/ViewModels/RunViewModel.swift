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
    @Published var distance: String = "0.00 km"
    @Published var speed: String = "0:00" //tempo i formatet min/km
    @Published var duration: String = "00:00" //tiden i formatet mm/ss
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7127, longitude: -73.998),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private var locationManager = LocationManager()
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0.0
    private var totalDistancee: Double = 0.0
    private var isPaused = false
    
    init() {
        locationManager.onLocationUpdate = { [weak self] location in
            self?.updateLocation(location)
        }
    }
    
    func startRun() {
        if isPaused {
            isPaused = false
            startTimer()
            locationManager.startTracking()
        } else {
            resetRun()
            locationManager.stopTracking()
            startTimer()
        }
    }
    
    func pauseRun() {
        isPaused = true
        stopTimer()
        locationManager.stopTracking()
    }
    
    func stopRun() {
        locationManager.stopTracking()
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
