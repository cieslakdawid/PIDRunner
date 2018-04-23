//
//  SpeedInfoView.swift
//  PIDRunner
//
//  Created by Dawid Cieslak on 22/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit

// Displays information about speed statistic data at given location
class StatisticsInfoView: UIView {
    
    /// Title for displayed value
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Label for main value
    private let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Bold", size: 24)
        label.textColor =  .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Did already set constrains
    private var didSetConstraints: Bool = false
    
    required init(title: String, initialValue: Double) {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.text = title
        update(value: initialValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard didSetConstraints == false else {
            return
        }
        
        didSetConstraints = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// Updates Value label with new data
    ///
    /// - Parameters:
    ///   - value: New value to be displayed
    func update(value: Double) {
        valueLabel.text = Formatter.decimalFormat(fractionDigits: 2).string(from: NSNumber(value: value))
    }
}
