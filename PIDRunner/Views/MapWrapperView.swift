//
//  MapWrapperView.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit
import Mapbox

/// Wraps map displaying run path
class MapWrapperView: UIView {
    
    var mapView: MGLMapView!
    var polylineSource: MGLShapeSource?
    
    
    /// Did already set constrains
    private var didSetConstraints: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let url = URL(string: "mapbox://styles/cieslakdawid/cjfr0lsls3tk82rqmf9ay48wm")
        mapView = MGLMapView(frame: frame, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

       mapView.delegate = self
       mapView.isUserInteractionEnabled = false
        
       addSubview(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Centers and zooms map around given point
    func centerMap() {
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.71786, longitude: -74.00030), zoomLevel: 13, animated: false)
        mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude:  40.71747,
                                                                              longitude:  -73.99228),
                                      fromDistance: 5000,
                                      pitch: 40,
                                      heading: 0)
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard didSetConstraints == false else {
            return
        }
        
        didSetConstraints = true
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func drawLine(_ points: [CLLocationCoordinate2D]) {
        updatePolylineWithCoordinates(coordinates: Array(points))
    }
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        guard coordinates.count > 0 else {
            polylineSource?.shape = nil
            return
        }
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }
}

// MARK: - MGLMapViewDelegate
extension MapWrapperView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        addLayer(to: style)
    }
    
    func addLayer(to style: MGLStyle) {
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineColor = MGLStyleValue(rawValue: UIColor(red: 9.0/255.0, green: 114.0/255.0, blue: 225.0/255.0, alpha: 1.0))
        
        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = MGLStyleValue(rawValue:  NSNumber(integerLiteral: 5))
        style.addLayer(layer)
    }
}


