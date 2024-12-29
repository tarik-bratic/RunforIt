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

@MainActor
class RunViewModel: NSObject, ObservableObject {
    @Published var distance: String = "0.00" // distance in km
    @Published var speed: String = "0:00" // tempo in min/km
    @Published var avrageSpeed: String = "0:00" // Avrage tempo in min/km
    @Published var duration: String = "00:00" // time in mm/ss
    
    @Published var runHistory: [Run] = []
    
    @Published var locationAccessDenied: Bool = false
    @Published var isFollowingLocation: Bool = true
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.27158, longitude: 17.98855),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private let locationManager = LocationManager()
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0.0
    private var lastLocationUpdateTime: TimeInterval?
    private var totalDistance: Double = 0.0
    private var lastLocation: CLLocation?
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
        
        DispatchQueue.main.async {
            self.isFollowingLocation = false
        }
    }
    
    func stopRun(mapView: MKMapView) {
        stopTimer()
        isPaused = false
        locationManager.stopTracking()
        
        // Capture map screenshot
        let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)
        let screenshot = renderer.image { ctx in
            mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
        }
        
        // Create a new Run entry
        let newRun = Run(
            date: Date(),
            distance: distance,
            duration: duration,
            averageSpeed: avrageSpeed,
            screenshot: screenshot,
            routeCoordinates: routeCoordinates
        )
        
        // Save the run to history
        runHistory.append(newRun)
        
        // Reset run data
        resetRun()
    }
    
    private func resetRun() {
        routeCoordinates = []
        totalDistance = 0.0
        elapsedTime = 0.0
        distance = "0.00"
        speed = "0:00"
        duration = "00:00"
        lastLocationUpdateTime = nil
        lastLocation = nil
    }
    
    private func setupLocationManager() {
        locationManager.onLocationUpdate = { [weak self] location in
            self?.updateLocation(location)
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in
                self.elapsedTime += 1
                self.updateDuration()
                self.updateAverageSpeed()
            }
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
                    self.updateCurrentSpeed(location, distanceDelta: distanceDelta)
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
    
    private func updateCurrentSpeed(_ location: CLLocation, distanceDelta: Double) {
        guard let lastUpdateTime = lastLocationUpdateTime else {
            lastLocationUpdateTime = elapsedTime
            lastLocation = location
            return
        }
        
        // Calculate time difference since the last update
        let timeDelta = elapsedTime - lastUpdateTime
        guard timeDelta > 0 else { return }
        
        // Current Speed (tempo) calculation
        let paceInSeconds = timeDelta / (distanceDelta / 1000)
        let minutes = Int(paceInSeconds) / 60
        let seconds = Int(paceInSeconds) % 60
        self.speed = String(format: "%d:%02d", minutes, seconds)
        
        // Update for the next calculation
        lastLocationUpdateTime = elapsedTime
        lastLocation = location
    }
    
    private func updateAverageSpeed() {
        guard totalDistance > 0, elapsedTime > 0 else {
            self.avrageSpeed = "0:00"
            return
        }
        
        // Avrage Speed (tempo) calculation
        let avgPaceInSeconds = elapsedTime / (totalDistance / 1000)
        let avgMinutes = Int(avgPaceInSeconds) / 60
        let avgSeconds = Int(avgPaceInSeconds) % 60
        self.avrageSpeed = String(format: "%d:%02d", avgMinutes, avgSeconds)
    }
}

