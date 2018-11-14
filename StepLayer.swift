//
//  StepLayer.swift
//  stepperSample
//
//  Created by Salarium on 13/11/2018.
//  Copyright © 2018 Salarium. All rights reserved.
//
import Foundation
import UIKit


class StepLayer: CAShapeLayer {
    
    enum Status: String {
        case active
        case done
        case inActive
    }

    var stepStatus: Status = .inActive {
        didSet {
            self.status(stepStatus)
        }
    }
    var data: (number: Int, img: UIImage?) = (0, UIImage()){
        didSet {
            self.initializeImageView()
        }
    }
    
    var isCurrent:Bool = false {
        didSet{
            self.updateStatus()
        }
    }
    
    var isFinished:Bool = false {
        didSet{
            self.updateStatus()
        }
    }
    
    private let annularPath = UIBezierPath()
    private var insideCircle = CALayer()
    private var iconLayer = CALayer()
    private let iconMaskLayer = CALayer()
    
    private var doneColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor)?
    private var inactiveColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor)?
    private var activeColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor)?
    
    //MARK: - Initialization
     init(doneColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor)?,
                  inactiveColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor)?,
                  activeColor: (outerCircle: UIColor, innerCircle: UIColor, iconColor: UIColor)?) {
        super.init()
        self.doneColor = doneColor
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    func initializeImageView() {
       
       
        let w2: CGFloat = self.bounds.size.width * 0.9
        let h2: CGFloat = self.bounds.size.height * 0.9
        let x2: CGFloat = self.bounds.size.width/2 - (w2/2)
        let y2: CGFloat = self.bounds.size.height/2 - (h2/2)
        insideCircle.frame = CGRect(x: x2, y: y2, width: w2, height: h2)
        insideCircle.cornerRadius = w2 / 2
        self.addSublayer(insideCircle)
        
       
        let myImage = data.img?.cgImage
        let w: CGFloat = self.bounds.size.width * 0.5
        let h: CGFloat = self.bounds.size.height * 0.5
        let x: CGFloat = self.bounds.size.width/2 - (w/2)
        let y: CGFloat = self.bounds.size.height/2 - (h/2)
        
        iconLayer.frame = CGRect(x: x, y: y, width: w, height: h)
        iconMaskLayer.frame =  iconLayer.bounds
        iconMaskLayer.contents = myImage
        iconLayer.mask = iconMaskLayer
        self.addSublayer(iconLayer)
        self.status(.done)
        
    }
 
    // MARK: - Functions
    func updateStatus() {
        if isFinished {
            self.path = nil
             self.status(.done)
        }
        else{
                if isCurrent {
                    self.status(.active)
                }
                else{
                     self.status(.inActive)
                }
            
        }
    }
    
    private func drawAnnularPath() {
        let sideLength = fmin(self.frame.width, self.frame.height)
        let circlesRadius = sideLength / 2.0 - self.lineWidth / 2.0
        
        self.annularPath.removeAllPoints()
        self.annularPath.addArc(withCenter: CGPoint(x:self.bounds.midX, y:self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        self.path = self.annularPath.cgPath
    }
    
    private func status(_ status: Status) {
        
        switch status {
        case .done:
            self.backgroundColor = doneColor!.outerCircle.cgColor
            insideCircle.backgroundColor = doneColor!.innerCircle.cgColor
            iconLayer.backgroundColor = doneColor!.iconColor.cgColor
            addShadow()
        case .active:
            self.backgroundColor = activeColor!.outerCircle.cgColor
            insideCircle.backgroundColor = activeColor!.innerCircle.cgColor
            iconLayer.backgroundColor = activeColor!.iconColor.cgColor
            noShadow()
        default:
            self.backgroundColor = inactiveColor!.outerCircle.cgColor
            insideCircle.backgroundColor = inactiveColor!.innerCircle.cgColor
            iconLayer.backgroundColor = inactiveColor!.iconColor.cgColor
            noShadow()
            break
        }
        
    }
    
    func noShadow() {
        self.masksToBounds = true
        self.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowRadius = 0
        self.shadowOpacity = 0
    }
    
    func addShadow() {
        self.masksToBounds = false
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowRadius = 1.5
        self.shadowOpacity = 0.5
    }
}
