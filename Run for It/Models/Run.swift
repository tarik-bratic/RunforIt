//
//  Run.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-29.
//

import Foundation
import UIKit
import CoreLocation

struct Run: Identifiable {
    let id = UUID()
    let date: Date
    let distance: String
    let duration: String
    let averageSpeed: String
    let screenshot: UIImage
    let routeCoordinates: [CLLocationCoordinate2D]
}
