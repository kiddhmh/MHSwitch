//
//  MHAnimationManager.swift
//  SwitchAnimation
//
//  Created by 胡明昊 on 17/1/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

import UIKit

class MHAnimationManager: NSObject {
    
    /// the duration is the face moving time not include spring animation
    private var animationDuration: CGFloat
    
    
    /// init
    init(animationDuration: CGFloat) {
        self.animationDuration = animationDuration
        super.init()
    }
    
    
    //MARK: - CAAnimation
    
    /// faceLayer move animation
    open func moveAnimation(fromPosition: CGPoint, toPosition: CGPoint) -> CABasicAnimation {
        
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = fromPosition
        moveAnimation.toValue = toPosition
        moveAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        moveAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = kCAFillModeForwards
        return moveAnimation
    }
 
    
    /// layer background color animation
    open func backgroundColorAnimation(fromValue: CGColor, toValue: CGColor) -> CABasicAnimation {
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = fromValue
        colorAnimation.toValue = toValue
        colorAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.fillMode = kCAFillModeForwards
        return colorAnimation
    }
    
    
    /// the eyes layer move
    open func eyeMoveAnimation(fromValue: CGFloat, toValue: CGFloat) -> CABasicAnimation {
        
        let moveAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        moveAnimation.fromValue = fromValue
        moveAnimation.toValue = toValue
        moveAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        moveAnimation.duration = CFTimeInterval(animationDuration / 3)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = kCAFillModeForwards
        return moveAnimation
    }
    
    
    /// mouth key frame animation
    open func mouthKeyFrameAnimation(WidthOffSet offSet: CGFloat, isOn: Bool) -> CAKeyframeAnimation {
        
        let frameNumber = animationDuration * 60 / 3
        var frameValue = isOn ? offSet : 0
        var arrayFrame = [CGFloat]()
        for _ in 0..<Int(frameNumber) {
            if isOn {
                frameValue = frameValue - offSet / frameNumber
            }else {
                frameValue = frameValue + offSet / frameNumber
            }
            arrayFrame.append(frameValue)
        }
        
        let keyAnimation = CAKeyframeAnimation(keyPath: "mouthOffSet")
        keyAnimation.values = arrayFrame
        keyAnimation.duration = CFTimeInterval(animationDuration / 4)
        if !isOn && animationDuration > 1 {
            keyAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(animationDuration / 12)
        }
        keyAnimation.isRemovedOnCompletion = false
        keyAnimation.fillMode = kCAFillModeForwards
        return keyAnimation
    }
    
  
    /// eyes close and open key frame animation
    open func eyesCloseAndOpenAnimation(rect: CGRect) -> CAKeyframeAnimation {
        
        let frameNumber = animationDuration * 180 / 9       // 180 frame erver second
        let eyesX = rect.origin.x
        var eyesY = rect.origin.y
        let eyesWidth = rect.size.width
        var eyesHeight = rect.size.height
        var arrayFrame = [CGRect]()
        for i in 0..<Int(frameNumber) {
            if i < Int(frameNumber) / 3 { //close
                eyesHeight = eyesHeight - rect.size.height / (frameNumber / 3)
            }else if i >= Int(frameNumber) / 3 && i < Int(frameNumber) * 2 / 3 { // zero
                eyesHeight = 0
            }else { // open
                eyesHeight = eyesHeight + rect.size.height / (frameNumber / 3)
            }
            
            eyesY = (rect.size.height - eyesHeight) / 2
            arrayFrame.append(CGRect(x: eyesX, y: eyesY, width: eyesWidth, height: eyesHeight))
        }
        
        let keyAnimation = CAKeyframeAnimation(keyPath: "eyeRect")
        keyAnimation.values = arrayFrame
        keyAnimation.duration = CFTimeInterval(animationDuration / 3)
        keyAnimation.isRemovedOnCompletion = false
        keyAnimation.fillMode = kCAFillModeForwards
        return keyAnimation
    }

}



