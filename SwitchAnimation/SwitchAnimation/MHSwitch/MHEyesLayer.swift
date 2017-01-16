//
//  MHEyesLayer.swift
//  SwitchAnimation
//
//  Created by 胡明昊 on 17/1/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

import UIKit

class MHEyesLayer: CALayer {
    
    /// public eye property
    open var eyeRect: CGRect = CGRect.zero
    
    open var mouthOffSet: CGFloat = 0.0
    
    open var eyeDistance: CGFloat?
    
    open var eyeColor: UIColor?
    
    open var isLiking: Bool?
    
    open var mouthY: CGFloat?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        
        super.init(layer: layer)
        let layer = layer as! MHEyesLayer
        eyeRect = layer.eyeRect
        mouthOffSet = layer.mouthOffSet
        eyeDistance = layer.eyeDistance
        eyeColor = layer.eyeColor
        isLiking = layer.isLiking
        mouthY = layer.mouthY
    }
    
    
    /// draw
    override func draw(in ctx: CGContext) {
        
        let bezierLeft = UIBezierPath(ovalIn: eyeRect)
        let bezierRight = UIBezierPath(ovalIn: CGRect(x: eyeDistance!, y: eyeRect.origin.y, width: eyeRect.size.width, height: eyeRect.size.height))
        
        var bezierMouth = UIBezierPath()
        let mouthWidth = eyeRect.size.width + eyeDistance!
        
        if isLiking! { // funny mouth
            bezierMouth.move(to: CGPoint(x: 0, y: mouthY!))
            bezierMouth.addCurve(to: CGPoint(x: mouthWidth, y: mouthY!), controlPoint1: CGPoint(x: mouthWidth - mouthOffSet * 3 / 4, y: mouthY! + mouthOffSet / 2), controlPoint2: CGPoint(x: mouthWidth - mouthOffSet / 4, y: mouthY! + mouthOffSet / 2))
        }else {
            bezierMouth = UIBezierPath(rect: CGRect(x: 0, y: mouthY!, width: mouthWidth, height: eyeRect.size.height / 4))
        }
        
        bezierMouth.close()
        ctx.addPath(bezierLeft.cgPath)
        ctx.addPath(bezierRight.cgPath)
        ctx.addPath(bezierMouth.cgPath)
        ctx.setFillColor(eyeColor!.cgColor)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.fillPath()
    }
    
    

    /// key animation
    override static func needsDisplay(forKey: String) -> Bool {
        
        if forKey == "mouthOffSet" { return true }
        if forKey == "eyeRect"     { return true }
        return super.needsDisplay(forKey: forKey)
    }
}
