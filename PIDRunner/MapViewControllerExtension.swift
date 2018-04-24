//
//  MapViewControllerExtension.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Just to keep main class easier to read during presentation
extension MapViewController {
    
    override func loadView() {
        super.loadView()
        view = mapView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.centerMap()
    }
}

// MARK: - SpeedDataProvider
extension MapViewController: SpeedDataProvider {
    var fullDistance: Double {
        return speedDataModel.fullDistance
    }
    
    func speedSample(at progress: CGFloat) -> SpeedMeasuredSample? {
        guard speedDataModel.speedData.isEmpty == false else {
            return nil
        }
        
        let lastSampleIndex = Int( CGFloat(speedDataModel.speedData.count - 1) * progress)
        return speedDataModel.speedData[lastSampleIndex]
    }
    
    func speedSample(before progress: CGFloat) -> [SpeedMeasuredSample] {
   
        let lastSampleIndex = Int( CGFloat(speedDataModel.speedData.count - 1) * progress  )
        let speedData = speedDataModel.speedData[0..<lastSampleIndex]
        
        return Array(speedData)
    }
    
    
}
