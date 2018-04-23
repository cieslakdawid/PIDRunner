//
//  CLLocationExtensions.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 23/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
