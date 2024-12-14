//
//  Run.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-11.
//

import Foundation
import CoreLocation

struct Run {
    var id: UUID
    var distance: Double
    var duration: TimeInterval
    var route: [CLLocationCoordinate2D]
}
