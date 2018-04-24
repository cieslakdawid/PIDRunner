//
//  MapView.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit
import CoreLocation

/// Wraps all UI components for training summary
class MapView: UIView {
    
    /// Temporary control for controlling displayed progress
    private var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        return slider
    }()
    
    /// Object responsible for providing information about speed
    weak var dataProvider: SpeedDataProvider? {
        didSet {
            updateUI()
        }
    }
    
    /// Displays map with run path
    private let mapWrapperView: MapWrapperView
    
    /// Provides visual representation of avg. speed during the training
    private let graphView: GraphView

    /// Displays information about avg. speed for given progress
    private let speedInfoView: StatisticsInfoView
    
    /// Displays information about distance related to average speed
    private let distanceInfoView: StatisticsInfoView
    
    /// Displays image view that can be pressed to show run stats. for position calculated from force touch read
    private let runImageView: UIImageView
    
    // Called when new slider changes value
    var sliderValueChanged: ((CGFloat) -> Void)? = nil
    
    required init(speedModel: SpeedModel) {
        graphView = GraphView(frame: .zero)
        speedInfoView = StatisticsInfoView(title: "Speed", initialValue: 0)
        distanceInfoView = StatisticsInfoView(title: "Distance", initialValue: 0)
        mapWrapperView = MapWrapperView(frame: .zero)
        runImageView = UIImageView(frame: .zero)
        super.init(frame: .zero)
        
        // Set listener
        progressSlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        
        // Run Image View
        runImageView.image = #imageLiteral(resourceName: "runIcon")
        runImageView.isUserInteractionEnabled = true
        
        // Add Subviews
        addSubview(mapWrapperView)
        addSubview(graphView)
        addSubview(progressSlider)
        addSubview(speedInfoView)
        addSubview(distanceInfoView)
        addSubview(runImageView)
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        speedInfoView.translatesAutoresizingMaskIntoConstraints = false
        distanceInfoView.translatesAutoresizingMaskIntoConstraints = false
        mapWrapperView.translatesAutoresizingMaskIntoConstraints = false
        runImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // Map
            self.mapWrapperView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapWrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mapWrapperView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapWrapperView.topAnchor.constraint(equalTo: self.topAnchor),
            
            // Graph
            self.graphView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.graphView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.graphView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.graphView.heightAnchor.constraint(equalToConstant: 40),
            
            /// Slider
            self.progressSlider.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 10),
            self.progressSlider.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
            self.progressSlider.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -10),
            
            // Distance Info
            self.distanceInfoView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
            self.distanceInfoView.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 10),
            
            // Speed Info
            self.speedInfoView.trailingAnchor.constraint(lessThanOrEqualTo: self.layoutMarginsGuide.trailingAnchor, constant: -10),
            self.speedInfoView.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 10),

            // Run Image View
            self.runImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            self.runImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
    }
    
    /// Updates all compoennts based on current data
    func updateUI() {
        guard let dataProvider = dataProvider else {
            return
        }
        
        // Draw graph
        let graphValues = dataProvider.speedSample(before: 1.0).map({ $0.averageSpeed })
        graphView.drawValues(graphValues)
        
        // Update Progress information
        updateData(for: 0.0)
    }
    
    // FIXME: Change this name
    func centerMap() {
        mapWrapperView.centerMap()
    }
    
    /// Update UI components to show data for given progress
    ///
    /// - Parameter progress: Progress relative to full distance. Provide value from 0.0 to 1.0
    func updateData(for progress: CGFloat) {
        
        // Make sure that progress is within range of 0.0 and 1.0
        let limitedProgress = min(1.0, max(0.0, progress))
        
        guard let speedData = dataProvider?.speedSample(before: limitedProgress) else {
            return
        }
       
        guard let speedDataAtProgress = dataProvider?.speedSample(at: limitedProgress) else {
            return
        }
        
       
        // Move Scrubber
        graphView.moveScrubber(to: limitedProgress)
        
        // Show stats about speed at given point
        speedInfoView.update(value: speedDataAtProgress.averageSpeed)
        distanceInfoView.update(value: dataProvider!.fullDistance * Double(limitedProgress))
        
        // Coordinates to be drawn as part on run path on map
       let coordinates = speedData.map({ CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)})
       mapWrapperView.drawLine(coordinates)
    }
    
    /// Called when slider changes value
    ///
    /// - Parameter sender: Object notifing about change
    @objc func sliderValueChanged(sender: UISlider) {
        let value = CGFloat(sender.value)
        sliderValueChanged?(value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
