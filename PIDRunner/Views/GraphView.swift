//
//  GraphView.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit

/// Displays speed as graph
class GraphView: UIView {
    
    private struct Constants {
        static let BackgroundColors: [CGColor] = [UIColor(red: 117.0/255.0, green: 102.0/255.0, blue: 1.0, alpha: 1.0).cgColor,
                                                  UIColor(red: 36.0/255.0, green: 176.0/255.0, blue: 1.0, alpha: 1.0).cgColor]
        
        static let ScrubberSize: CGFloat = 8.0
    }
    
    /// Array of values that should be represented on graph
    private var rawValues: [Double]? = nil
    
    /// Layer with gradient background
    private let gradientBackground = CAGradientLayer()
    
    /// Speed converted into shape
    private let graphShape: CAShapeLayer = CAShapeLayer()
    
    /// Shows where is current preview
    private let scrubberView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    /// Keeps track of latest progress set (When moving scrubber)
    private var currentProgress: CGFloat = 0
 
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(gradientBackground)
        addSubview(scrubberView)
        
        backgroundColor = UIColor.clear
        gradientBackground.backgroundColor = UIColor.clear.cgColor
        scrubberView.backgroundColor = UIColor.white
        
        gradientBackground.colors = Constants.BackgroundColors
        gradientBackground.locations = [0.0, 1.0]
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawValues(_ values: [Double]) {
       rawValues = normalizeValues(values)
       setNeedsDisplay()
    }
    
    private func normalizeValues(_ values: [Double]) -> [Double] {
    // Find maximum value in provided set
        var maximumValue: Double = 0
        for value in values { maximumValue = max(maximumValue, value) }
        
            // Recalculate speed values to graph values
        var normalisedValues: [Double] = [Double]()
        for value in values {
            let normalizedValue = value / maximumValue
            normalisedValues.append(normalizedValue)
        }
        
        return normalisedValues
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientBackground.frame = bounds
        scrubberView.frame = CGRect(x: currentProgress*(bounds.width-Constants.ScrubberSize), y: 0, width: Constants.ScrubberSize, height: Constants.ScrubberSize)
        scrubberView.layer.cornerRadius = Constants.ScrubberSize/2
    }
    
    /// Create path based on provided information about average speed
    ///
    /// - Returns: Path representaing avg. speed for the whole training
    private func path(for rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        guard let graphValues = rawValues else {
            return path
        }
        
        let widthPoints = Int(rect.width)
        
        path.move(to: CGPoint(x: 0, y: 0))
        for i in 0..<widthPoints {
            let progress = CGFloat(i) / CGFloat(widthPoints)
            let graphValueIndex = Int(progress * CGFloat(graphValues.count))
            let normalizedValue = CGFloat(graphValues[graphValueIndex])
            
            let valuePoint = CGPoint(x: CGFloat(i), y: rect.height - normalizedValue*rect.height)
            path.addLine(to: valuePoint)
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        return path
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maskLayer = CAShapeLayer()
        let shapePath =  path(for: rect).cgPath
        maskLayer.path = shapePath
        gradientBackground.mask = maskLayer
    }
    
    /// Moves scrubber to given position
    ///
    /// - Parameter to: Position of scrubber (0.0 to 1.0)
    func moveScrubber(to: CGFloat) {
        currentProgress = to
        guard let rawValues = rawValues else {
            return
        }
        
        let width = bounds.width
        let graphValueIndex = Int(to * CGFloat(rawValues.count - 1))
        let normalizedValue = CGFloat(rawValues[graphValueIndex])
        let valuePoint = CGPoint(x: CGFloat(to*width), y: bounds.height - normalizedValue*bounds.height)
       
        scrubberView.center = valuePoint
    }
}
