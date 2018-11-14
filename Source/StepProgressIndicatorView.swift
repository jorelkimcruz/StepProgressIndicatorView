//
//  Stepper.swift
//  stepperSample
//
//  Created by Salarium on 13/11/2018.
//  Copyright © 2018 Salarium. All rights reserved.
//

import Foundation
import UIKit


public enum StepIndicatorViewDirection:UInt {
    case leftToRight = 0, rightToLeft, topToBottom, bottomToTop
}

@IBDesignable open class StepProgressIndicatorView: UIView {
   
    private let containerLayer = CALayer()
    private var stepLayer: StepLayer!
    private var stepLayerArray = [StepLayer]()
    private var horizontalLineLayers = [LineLayer]()
    
    public var doneColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor) = (UIColor.white,  UIColor.white, UIColor.black)
    
    public var inactiveColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor) = (UIColor.init(red: 65.0/255.0, green: 162.0/255.0, blue: 153.0/255.0, alpha: 1.0),  UIColor.init(red: 65.0/255.0, green: 162.0/255.0, blue: 153.0/255.0, alpha: 1.0), UIColor.init(red: 64.0/255.0, green: 186.0/255.0, blue: 174.0/255.0, alpha: 1.0))
    
    public var activeColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor) = (UIColor.init(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 0.6),  UIColor.white, UIColor.init(red: 64.0/255.0, green: 186.0/255.0, blue: 174.0/255.0, alpha: 1.0))
    
    public var icons: [UIImage?] = [] {
        didSet {
              self.createSteps()
        }
    }
    
    public var circleRadius: CGFloat = 30 {
        didSet {
            self.updateSubLayers()
        }
    }
    
     public var lineMargin: CGFloat = 3.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    
     public var currentStep: Int = 0 {
        didSet{
            if self.stepLayerArray.count == 0 {
                return
            }
            if oldValue != self.currentStep {
                self.setCurrentStep(step: self.currentStep)
            }
        }
    }
    //==== for animation
    
    public var direction:StepIndicatorViewDirection = .leftToRight {
        didSet{
            self.updateSubLayers()
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    func commonInit() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gestureAction(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func gestureAction(_ gestureRecognizer: UIGestureRecognizer) {
      
    }
    
    
    // MARK: - Functions
    private func createSteps() {
        if let layers = self.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        self.stepLayerArray.removeAll()
        self.horizontalLineLayers.removeAll()
        
        if self.icons.count <= 0 {
            return
        }
        
        for i in 0..<self.icons.count {
            let annularLayer = StepLayer(doneColor: self.doneColor, inactiveColor: self.inactiveColor, activeColor: self.activeColor)
            self.containerLayer.addSublayer(annularLayer)
            self.stepLayerArray.append(annularLayer)
            
            if (i < self.icons.count - 1) {
                let lineLayer = LineLayer()
                self.containerLayer.addSublayer(lineLayer)
                self.horizontalLineLayers.append(lineLayer)
            }
        }
        
        self.layer.addSublayer(self.containerLayer)
        
        self.updateSubLayers()
        self.setCurrentStep(step: 0)
    }
    
    private func updateSubLayers() {
        self.containerLayer.frame = self.layer.bounds
        
        self.layoutHorizontal()
        
        self.applyDirection()
    }
    
    private func layoutHorizontal() {
        let diameter = self.circleRadius * 2
        let stepWidth = self.icons.count == 1 ? 0 : (self.containerLayer.frame.width - diameter) / CGFloat(self.icons.count - 1)
        let y = self.containerLayer.frame.height / 2.0
        
        for i in 0..<self.stepLayerArray.count {
            let annularLayer = self.stepLayerArray[i]
            
            let x = self.icons.count == 1 ? self.containerLayer.frame.width / 2.0 - self.circleRadius : CGFloat(i) * stepWidth
            annularLayer.frame = CGRect(x: x, y: y - self.circleRadius, width: diameter, height: diameter)
            annularLayer.isCurrent = i == self.currentStep ? true : false
            self.applyAnnularStyle(layer: annularLayer)
            annularLayer.data = (i + 1, self.icons[i])
            if (i < self.icons.count - 1) {
                let lineLayer = self.horizontalLineLayers[i]
                lineLayer.frame = CGRect(x: CGFloat(i) * stepWidth + diameter, y: y - 1, width: stepWidth - diameter, height: 3)
                self.applyLineStyle(lineLayer: lineLayer)
                lineLayer.updateStatus()
            }
        }
        
        self.containerLayer.frame.origin.x = self.frame.origin.x
    }
    
    private func applyAnnularStyle(layer:StepLayer) {
        layer.cornerRadius = circleRadius
    }
    
    private func applyLineStyle(lineLayer:LineLayer) {
        lineLayer.strokeColor = UIColor.init(red: 65.0/255.0, green: 162.0/255.0, blue: 153.0/255.0, alpha: 1.0).cgColor
        lineLayer.lineWidth = 4
        lineLayer.tintColor = UIColor.white
    }
    
    private func applyDirection() {
        switch self.direction {
        case .rightToLeft:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.stepLayerArray {
                annularLayer.transform = rotation180
            }
        case .bottomToTop:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.stepLayerArray {
                annularLayer.transform = rotation180
            }
        default:
            self.containerLayer.transform = CATransform3DIdentity
            for annularLayer in self.stepLayerArray {
                annularLayer.transform = CATransform3DIdentity
            }
        }
    }
    
    
    private func setCurrentStep(step:Int) {
        for i in 0..<self.stepLayerArray.count {
            if i < step {
                if !self.stepLayerArray[i].isFinished {
                    self.stepLayerArray[i].isFinished = true
                }
                
                self.setLineFinished(isFinished: true, index: i - 1)
            }
            else if i == step {
                self.stepLayerArray[i].isFinished = false
                self.stepLayerArray[i].isCurrent = true
                
                self.setLineFinished(isFinished: true, index: i - 1)
            }
            else{
                self.stepLayerArray[i].isFinished = false
                self.stepLayerArray[i].isCurrent = false
                
                self.setLineFinished(isFinished: false, index: i - 1)
            }
        }
    }
    
    private func setLineFinished(isFinished:Bool,index:Int) {
        if index >= 0 {
            if self.horizontalLineLayers[index].isFinished != isFinished {
                self.horizontalLineLayers[index].isFinished = isFinished
            }
        }
    }
}
