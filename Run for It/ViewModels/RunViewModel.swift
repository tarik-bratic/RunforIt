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

class RunViewModel: NSObject, ObservableObject {
    @Published var distance: String = "0.00" // distance in km
    @Published var speed: String = "0:00" // tempo in min/km
    @Published var avrageSpeed: String = "0:00" // Avrage tempo in min/km
    @Published var duration: String = "00:00" // time in mm/ss
    
    @Published var locationAccessDenied: Bool = false
    @Published var isFollowingLocation: Bool = true
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private let locationManager = LocationManager()
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0.0
    private var totalDistance: Double = 0.0
    private var isPaused = false
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func startRun() {
        if !isPaused { resetRun() }
        isPaused = false
        startTimer()
        locationManager.startTracking()
    }
    
    func pauseRun() {
        isPaused = true
        stopTimer()
        locationManager.stopTracking()
    }
    
    func stopRun() {
        stopTimer()
        isPaused = false
        locationManager.stopTracking()
    }
    
    private func resetRun() {
        routeCoordinates = []
        totalDistance = 0.0
        elapsedTime = 0.0
        distance = "0.00"
        speed = "0:00"
        duration = "00:00"
    }
    
    private func setupLocationManager() {
        locationManager.onLocationUpdate = { [weak self] location in
            self?.updateLocation(location)
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
    
    private func updateLocation(_ location: CLLocation) {
        DispatchQueue.main.async {
            if let lastCoordinates = self.routeCoordinates.last {
                let lastLocation = CLLocation(latitude: lastCoordinates.latitude, longitude: lastCoordinates.longitude)
                let distanceDelta = location.distance(from: lastLocation)
                
                if distanceDelta > 1 {
                    self.totalDistance += distanceDelta
                    self.distance = String(format: "%.2f", self.totalDistance / 1000)
                    self.updateSpeed()
                }
            }
            
            self.routeCoordinates.append(location.coordinate)
            
            if self.isFollowingLocation {
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
    }
    
    private func updateDuration() {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        self.duration = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateSpeed() {
        guard totalDistance > 0, elapsedTime > 0 else {
            self.speed = "0:00"
            self.avrageSpeed = "0:00"
            return
        }
        
        // Current Speed (tempo) calculation
        let paceInSeconds = elapsedTime / (totalDistance / 1000)
        let minutes = Int(paceInSeconds) / 60
        let seconds = Int(paceInSeconds) % 60
        self.speed = String(format: "%d:%02d", minutes, seconds)
        
        // Avrage Speed (tempo) calculation
        let avgPaceInSeconds = elapsedTime / (totalDistance / 1000)
        let avgMinutes = Int(avgPaceInSeconds) / 60
        let avgSeconds = Int(avgPaceInSeconds) % 60
        self.avrageSpeed = String(format: "%d:%02d", avgMinutes, avgSeconds)
    }
}

