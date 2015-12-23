//
//  ClockProgressView.swift
//  ClockProgressView
//
//  Created by Adrian Lesniak on 22/12/2015.
//  Copyright © 2015 Adrian Lesniak. All rights reserved.
//

import UIKit

@IBDesignable
class ClockProgressView: UIView {

    var showing = false
    
    
    // Layers
    
    var clockFaceLayer: CAShapeLayer!
    var clockBorderLayer: CAShapeLayer!
    var longNeedleLayer: CAShapeLayer!
    var shortNeedleLayer: CAShapeLayer!
    var pinLayer: CAShapeLayer!
    
    var needlePinRadiusScale: CGFloat = 0.07
    var longNeedleHeightScale: CGFloat = 0.85
    var shortNeedleHeightScale: CGFloat = 0.6
    
    @IBInspectable
    var borderWidth: CGFloat = 8.0 {
        didSet {
            self.clockBorderLayer.lineWidth = borderWidth
        }
    }
    
    @IBInspectable
    var longNeedleRotateDuration: Double = 5.0 {
        didSet {
            animatableLayers[0].duration = longNeedleRotateDuration
            animatableLayers[0].duration = longNeedleRotateDuration/12
        }
    }
    
    @IBInspectable
    var clockFaceColor: UIColor = UIColor.redColor() {
        didSet {
            self.clockFaceLayer.fillColor = clockFaceColor.CGColor
        }
    }
    @IBInspectable
    var needleColor: UIColor = UIColor.blackColor() {
        didSet {
            self.longNeedleLayer.fillColor = needleColor.CGColor
            self.shortNeedleLayer.fillColor = needleColor.CGColor
            self.pinLayer.fillColor = needleColor.CGColor
        }
    }
    @IBInspectable
    var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.clockBorderLayer.strokeColor = borderColor.CGColor
        }
    }
    
    var animatableLayers = Array<CALayer>()
    
    var rotationAnimation: CABasicAnimation {
        get {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0
            animation.toValue = degreesToRadians(360)
            animation.repeatCount = Float.infinity
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.9
            
            return animation
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.hidden = !showing
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.opaque = false
        
        // View shadow
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.0
        
        
        self.drawLayers()
    }
    
    func drawLayers() {
        
        let pinRadius: CGFloat =  (max(self.frame.size.width, self.frame.size.height)) * needlePinRadiusScale
        
        let clockFaceRect: CGRect = CGRectMake(0, 0, self.frame.width, self.frame.height)
        let clockFacePath: UIBezierPath = UIBezierPath(ovalInRect: clockFaceRect)
        
        
        // Clock border
        
        self.clockBorderLayer = CAShapeLayer()
        self.clockBorderLayer.path = clockFacePath.CGPath
        self.clockBorderLayer.strokeColor = self.borderColor.CGColor
        self.clockBorderLayer.lineWidth = self.borderWidth
        self.layer.addSublayer(self.clockBorderLayer)
        
        
        // Clock face
        
        self.clockFaceLayer = CAShapeLayer()
        self.clockFaceLayer.path = clockFacePath.CGPath
        self.clockFaceLayer.fillColor = clockFaceColor.CGColor
        self.layer.addSublayer(self.clockFaceLayer)
        
        
        // Long clock needles
        
        let longNeedlePath: UIBezierPath = UIBezierPath()
        longNeedlePath.moveToPoint(CGPoint(x: self.frame.width/2 - pinRadius, y: self.frame.height/2))
        longNeedlePath.addLineToPoint(CGPoint(x: self.frame.width/2, y: self.frame.size.height/2 - (self.frame.size.height/2*longNeedleHeightScale)))
        longNeedlePath.addLineToPoint(CGPoint(x: self.frame.width/2 + pinRadius, y: self.frame.size.height/2))
        longNeedlePath.closePath()
        
        self.longNeedleLayer = CAShapeLayer()
        self.longNeedleLayer.fillColor = needleColor.CGColor
        self.longNeedleLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.longNeedleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.longNeedleLayer.path = longNeedlePath.CGPath
        self.layer.addSublayer(self.longNeedleLayer)
        self.animatableLayers.append(self.longNeedleLayer)
        
        // Short clock needles
        
        let shortNeedlePath: UIBezierPath = UIBezierPath()
        shortNeedlePath.moveToPoint(CGPoint(x: self.frame.width/2 - pinRadius, y: self.frame.height/2))
        shortNeedlePath.addLineToPoint(CGPoint(x: self.frame.width/2, y: self.frame.size.height/2 - (self.frame.size.height/2*shortNeedleHeightScale)))
        shortNeedlePath.addLineToPoint(CGPoint(x: self.frame.width/2 + pinRadius, y: self.frame.size.height/2))
        shortNeedlePath.closePath()
        
        self.shortNeedleLayer = CAShapeLayer()
        self.shortNeedleLayer.fillColor = needleColor.CGColor
        self.shortNeedleLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.shortNeedleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.shortNeedleLayer.path = longNeedlePath.CGPath
        self.layer.addSublayer(self.shortNeedleLayer)
        self.animatableLayers.append(self.shortNeedleLayer)
        
        
        // Needle pin
        
        let pinRect: CGRect = CGRectMake(self.frame.size.width/2 - pinRadius, self.frame.size.height/2 - pinRadius, pinRadius*2, pinRadius*2)
        let pinPath: UIBezierPath = UIBezierPath(ovalInRect: pinRect)
        
        self.pinLayer = CAShapeLayer()
        self.pinLayer.path = pinPath.CGPath
        self.pinLayer.fillColor = self.needleColor.CGColor
        self.layer.addSublayer(self.pinLayer)
        
        self.toggleAnimationsOnLayers()
    }
    
    func createRotationAnimationWithDuration(duration: Double) -> CABasicAnimation {
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = degreesToRadians(360)
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        
        return animation
    }
    
    func toggle() {
        
        self.transform = showing ? CGAffineTransformMakeScale(1.0, 1.0) : CGAffineTransformMakeScale(0.01, 0.01)
        self.alpha = showing ? 1.0 : 0.0
        self.hidden = false
        
        UIView.animateWithDuration(showing ? 0.25 : 0.35, delay: 0.0, usingSpringWithDamping: showing ? 0.00 : 0.5, initialSpringVelocity: showing ? 0.0 : 1.0, options: .CurveEaseIn, animations: {
            
            self.transform = self.showing ? CGAffineTransformMakeScale(10.0, 10.0) : CGAffineTransformMakeScale(1.0, 1.0)
            self.alpha = self.showing ? 0.0 : 1.0
            
            }, completion: {
        
            (_) in
            
            self.showing = !self.showing
            self.hidden = !self.showing
            self.toggleAnimationsOnLayers();
                
        })
     }
    
    func toggleAnimationsOnLayers() {
        
        if self.showing {
            animatableLayers[0].addAnimation(self.createRotationAnimationWithDuration(longNeedleRotateDuration), forKey: "longNeedleRotation")
            animatableLayers[1].addAnimation(self.createRotationAnimationWithDuration(longNeedleRotateDuration/12), forKey: "shortNeedleRotation")
        }
        
        else {
            animatableLayers[0].removeAllAnimations()
            animatableLayers[1].removeAllAnimations()
        }
        
    }
    
    func degreesToRadians(degreeValue: CGFloat) -> CGFloat {
        return CGFloat(degreeValue) * CGFloat(M_PI) / 180.0
    }
}
