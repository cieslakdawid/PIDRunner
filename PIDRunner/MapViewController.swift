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

    var pidController: Pulse? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to slider changes
        mapView.sliderValueChanged = { [weak self] value in
            guard let `self` = self else { return }
            // value from 0.0 -> 1.0
            self.pidController?.setPoint = value
        }
        
        let configuration = Pulse.Configuration(minimumValueStep: 0.005, Kp: 1.2, Ki: 0.1, Kd: 0.4)
        pidController = Pulse(configuration: configuration,  measureClosure: { [weak self] () -> CGFloat in
             guard let `self` = self else { return 0 }
            return self.currentProgress
        }, outputClosure: { (output) in
            self.currentProgress = output
            self.mapView.updateData(for: self.currentProgress)
        })
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let normalizedForce = firstTouch.force / firstTouch.maximumPossibleForce
             self.pidController?.setPoint = normalizedForce
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.pidController?.setPoint = 0
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(motion == .motionShake) {
            pidController?.showTunningView(minimumValue: -1, maximumValue: 1)
        }
    }
    
    
}
