//
//  SpeedDataProvider.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit

/// Interface for objects providing information about average speed
protocol SpeedDataProvider: class {
    
    /// Provides information about average speed at specyfic location
    ///
    /// - Parameter progress: Position of sample, relative to full distance. Provide value from 0.0 to 1.0
    /// - Returns: Information about speed, nearest to provided `progress`
    func speedSample(at progress: CGFloat) -> SpeedMeasuredSample?
    
    ///  Provides information about all average speed calculated before given `progress`
    ///
    /// - Parameter progress: Maximum position of speed sample, relative to full distance. Provide value from 0.0 to 1.0
    /// - Returns: Array of all measured samples before given `progress`
    func speedSample(before progress: CGFloat) -> [SpeedMeasuredSample]
    
    /// Provides information how long is full distance (in KM)
    var fullDistance: Double { get }
}
