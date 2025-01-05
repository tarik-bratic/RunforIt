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

/// ViewModel responsible for managing and tracking running sessions
@MainActor
class RunViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties (UI Updates)
    @Published var distance: String = "0.00" // Distance covered in kilometers
    @Published var speed: String = "0:00" // Current pace (min/km)
    @Published var averageSpeed: String = "0:00" // Average pace (min/km)
    @Published var duration: String = "00:00" // Total duration (hh:mm:ss)
    @Published var runHistory: [Run] = [] // Completed runs
    @Published var locationAccessDenied: Bool = false // Location access status
    @Published var isFollowingLocation: Bool = true // Follow location on map
    @Published var routeCoordinates: [CLLocationCoordinate2D] = [] // Recorded route
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.27158, longitude: 17.98855),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // MARK: - Private Properties
    private let locationManager = LocationManager() // Handles location updates
    private var timer: Timer? // Tracks running duration
    private var elapsedTime: TimeInterval = 0.0 // Total elapsed time
    private var lastLocationUpdateTime: TimeInterval? // Time of the last location update
    private var totalDistance: Double = 0.0 // Total distance covered in meters
    private var lastLocation: CLLocation? // Last recorded location
    private var isPaused = false // Paused state for the run
    
    // MARK: - Initializer
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Public Methods
    /// Starts or resumes a run
    func startRun() {
        if !isPaused { resetRun() } // Reset if not resuming
        isPaused = false
        
        if let currentLocation = locationManager.routeCoordinates.last {
            // Update map region to user's location
            region = MKCoordinateRegion(
                center: currentLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        
        startTimer()
        locationManager.startTracking()
    }
    
    /// Pauses the run
    func pauseRun() {
        isPaused = true
        stopTimer()
        locationManager.stopTracking()
        isFollowingLocation = false
    }
    
    /// Stops the run and saves it to history
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
            averageSpeed: averageSpeed,
            screenshot: screenshot,
            routeCoordinates: routeCoordinates
        )
        saveRunToHistory(newRun)
        resetRun()
    }
    
    // MARK: - Private Methods
    /// Resets run data
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
    
    /// Adds a new run to history and sorts by date
    private func saveRunToHistory(_ run: Run) {
        runHistory.append(run)
        runHistory.sort { $0.date > $1.date }
    }
    
    /// Configures the location manager to handle location updates
    private func setupLocationManager() {
        locationManager.onLocationUpdate = { [weak self] location in
            self?.handleLocationUpdate(location)
        }
    }
    
    /// Starts a timer to update duration and average speed
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
    
    /// Stops the timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Handles updates to the user's location
    private func handleLocationUpdate(_ location: CLLocation) {
        guard let lastCoordinates = routeCoordinates.last else {
            // First location update
            routeCoordinates.append(location.coordinate)
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            return
        }
        
        // Calculate distance delta and update total distance
        let lastLocation = CLLocation(latitude: lastCoordinates.latitude, longitude: lastCoordinates.longitude)
        let distanceDelta = location.distance(from: lastLocation)
        if distanceDelta > 1 { // Avoid noise
            totalDistance += distanceDelta
            distance = String(format: "%.2f", totalDistance / 1000) // Convert to kilometers
            updateCurrentSpeed(location, distanceDelta: distanceDelta)
        }
        
        routeCoordinates.append(location.coordinate)
        if isFollowingLocation {
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    /// Updates the total duration of the run
    private func updateDuration() {
        duration = formatTime(elapsedTime)
    }
    
    /// Formats time intervals as 'hh:mm:ss' or 'mm:ss'
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        
        return hours > 0
            ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            : String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    /// Updates the current speed (pace)
    private func updateCurrentSpeed(_ location: CLLocation, distanceDelta: Double) {
        guard let lastUpdateTime = lastLocationUpdateTime else {
            lastLocationUpdateTime = elapsedTime
            lastLocation = location
            return
        }
        
        let timeDelta = elapsedTime - lastUpdateTime
        guard timeDelta > 0 else { return }
        
        let paceInSeconds = timeDelta / (distanceDelta / 1000)
        speed = formatTime(paceInSeconds)
        lastLocationUpdateTime = elapsedTime
        lastLocation = location
    }
    
    /// Updates the average speed (pace)
    private func updateAverageSpeed() {
        guard totalDistance > 0, elapsedTime > 0 else {
            averageSpeed = "0:00"
            return
        }
        
        let avgPaceInSeconds = elapsedTime / (totalDistance / 1000)
        averageSpeed = formatTime(avgPaceInSeconds)
    }
}

