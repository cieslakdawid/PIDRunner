//
//  MapViewController.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit
import PulseController

class MapViewController: UIViewController {
    
    /// Wraps all UI components for this ViewController
    var mapView: MapView
    
    /// Data model with route coordinates and average speed
    var speedDataModel: SpeedModel
    
    /// Latest value of progress set by user
    var currentProgress: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to slider changes
        mapView.sliderValueChanged = { value in
           self.mapView.updateData(for: value)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        guard let model = SpeedModel.with(file: "speedData") else {
            fatalError("Cannot read JSON data")
        }
        self.speedDataModel = model
        self.mapView = MapView(speedModel: self.speedDataModel)
        super.init(coder: aDecoder)
        
        mapView.dataProvider = self
    }
}
