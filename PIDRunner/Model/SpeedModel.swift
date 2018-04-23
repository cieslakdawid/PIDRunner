//
//  SpeedModel.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit
import CoreLocation
/// Represents single sample
struct SpeedMeasuredSample {
    /// Where sample was calculated
    let coordinate: CLLocationCoordinate2D
    
    /// Value of average speed untill this point
    let averageSpeed: Double
}

// MARK: - Parsing
extension SpeedMeasuredSample {
    /// Parses Any object to Speed Measured Sample
    ///
    /// - Parameter any: Dictionary with value
    /// - Returns: Speed sample with coordinates and speed
    static func with(_ dict: Any) -> SpeedMeasuredSample? {
        
       
        guard let dict = dict as? [String:Any] else {
            return nil
        }
        
        guard let coordinates = dict["position"] as? [String:Double] else {  return nil }
        guard let latitude = coordinates["x"] else {  return nil }
        guard let longitude = coordinates["y"]  else {  return nil }
        
        guard let speed = dict["speed"] as? Double else {  return nil }
        
        return SpeedMeasuredSample(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), averageSpeed: speed)
    }
}
/// Contains statistic data about speed during training
struct SpeedModel {
    
    /// Whole distanse (in Km)
    let fullDistance: Double
    
    /// Measured average speed
    let speedData: [SpeedMeasuredSample]
}

extension SpeedModel {
    static func with(file: String) -> SpeedModel? {
        if let filePath = Bundle.main.path(forResource: file, ofType: "json"),
            let data = NSData(contentsOfFile: filePath) {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                guard let samples = jsonData as? [String:Any]  else {
                   return nil
                }
                
                guard let speedData = samples["speedData"] as? [Any] else {
                    return nil
                }
                
                var speedSamples = [SpeedMeasuredSample]()
                var fullDistance: Double = 0.0
                var previousCoordinates: CLLocationCoordinate2D? = nil
                for element in speedData {
                    guard let parsedSample =  SpeedMeasuredSample.with(element) else {
                       continue
                    }
                    
                    if let previousCoordinates = previousCoordinates {
                         fullDistance += CLLocation.distance(from: previousCoordinates, to: parsedSample.coordinate)
                    }
                    previousCoordinates = parsedSample.coordinate
                    speedSamples.append(parsedSample)
                   
                }
                return SpeedModel(fullDistance: fullDistance / 1000, speedData: speedSamples)
            }
            catch {
                assertionFailure("Cannot read JSON file")
            }
        }
        
        return nil
    }
}
