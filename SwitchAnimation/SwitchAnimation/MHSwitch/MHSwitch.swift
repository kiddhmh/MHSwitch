//
//  MHSwitch.swift
//  SwitchAnimation
//
//  Created by 胡明昊 on 17/1/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

import UIKit

@objc protocol MHSwitchDelegate: NSObjectProtocol {
    
    @objc optional func didTapMHSwitch(mhSwitch: MHSwitch)
    
    @objc optional func animationDidStopForMHSwitch(mhSwitch: MHSwitch)
    
    @objc optional func valueDidChanged(mhSwitch: MHSwitch, isOn: Bool)
}

@IBDesignable
class MHSwitch: UIView {
    
    // MARK: - Public Properties
    /// switch on color
    @IBInspectable open var onColor: UIColor = UIColor(red: 74/255.0, green: 182/255.0, blue: 235/255.0, alpha: 1.0) {
        didSet {
            mhonColor = onColor
            guard mhisOn else { return }
            backgroundView.backgroundColor = onColor
            eyesLayer.eyeColor = onColor
            eyesLayer.setNeedsDisplay()
        }
    }
    
    /// switch off color
    @IBInspectable open var offColor: UIColor = UIColor(red: 211/255.0, green:207/255.0, blue:207/255.0, alpha: 1.0) {
        didSet {
            mhoffColor = offColor
            guard !mhisOn else { return }
            backgroundView.backgroundColor = offColor
            eyesLayer.eyeColor = offColor
            eyesLayer.setNeedsDisplay()
        }
    }
    
    /// face on and off color
    @IBInspectable open var faceColor: UIColor = .white {
        didSet {
            mhfaceColor = faceColor
            circleFaceLayer.fillColor = faceColor.cgColor
        }
    }
    
    /// the duration is the face moving time
    @IBInspectable open var animationDuration: CGFloat = 1.2 {
        didSet {
            mhanimationDuration = animationDuration
            animationManager = MHAnimationManager(animationDuration: animationDuration)
        }
    }
    
    /// the switch status is or isn't on
    @IBInspectable open var isOn: Bool = false {

        didSet (oldValue) {
            
            if (isOn && oldValue) || (!isOn && !oldValue) { return }
            
            if isOn {
                backgroundView.layer.removeAllAnimations()
                backgroundView.backgroundColor = mhonColor
                circleFaceLayer.removeAllAnimations()
                circleFaceLayer.position = CGPoint(x: circleFaceLayer.position.x + moveDistance!, y: circleFaceLayer.position.y)
                eyesLayer.eyeColor = mhonColor
                eyesLayer.isLiking = true
                eyesLayer.mouthOffSet = eyesLayer.frame.size.width
                eyesLayer.needsDisplay()
            }else {
                backgroundView.layer.removeAllAnimations()
                backgroundView.backgroundColor = mhoffColor
                circleFaceLayer.removeAllAnimations()
                circleFaceLayer.position = CGPoint(x: circleFaceLayer.position.x - moveDistance!, y:circleFaceLayer.position.y)
                eyesLayer.eyeColor = mhoffColor
                eyesLayer.isLiking = false
                eyesLayer.mouthOffSet = 0
                eyesLayer.needsDisplay()
            }
            mhisOn = isOn
        }
    }
    
    @IBOutlet open weak var delegate: MHSwitchDelegate?
    
    override var backgroundColor: UIColor? {
        didSet {
            return
        }
    }
    
    // MARK: - private Properties
    /// switch background view
    private lazy var backgroundView: UIView = { [unowned self] in
        let backgroundView = UIView()
        backgroundView.frame = self.bounds
        backgroundView.layer.cornerRadius = self.frame.size.height / 2
        backgroundView.layer.masksToBounds = true
        self.addSubview(backgroundView)
        return backgroundView
    }()
    
    /// face layer
    fileprivate lazy var circleFaceLayer: CAShapeLayer = { [unowned self] in
        let circleFaceLayer = CAShapeLayer()
        circleFaceLayer.frame = CGRect(x: self.paddingWidth!, y: self.paddingWidth!, width: self.circleFaceRadius! * 2, height: self.circleFaceRadius! * 2)
        let circlePath = UIBezierPath(ovalIn: circleFaceLayer.bounds)
        circleFaceLayer.path = circlePath.cgPath
        self.backgroundView.layer.addSublayer(circleFaceLayer)
        return circleFaceLayer
    }()
    
    /// eyes layer
    fileprivate lazy var eyesLayer: MHEyesLayer = { [unowned self] in
        let eyeslayer: MHEyesLayer = MHEyesLayer()
        eyeslayer.eyeRect = CGRect(x: 0, y: 0, width: self.faceLayerWidth! / 6, height: self.circleFaceLayer.frame.size.height * 0.22)
        eyeslayer.eyeDistance = self.faceLayerWidth! / 3
        eyeslayer.eyeColor = self.mhoffColor
        eyeslayer.isLiking = false
        eyeslayer.mouthY = eyeslayer.eyeRect.size.height * 7 / 4
        eyeslayer.frame = CGRect(x: self.faceLayerWidth! / 4, y: self.circleFaceLayer.frame.size.height * 0.28, width: self.faceLayerWidth! / 2, height: self.circleFaceLayer.frame.size.height * 0.72)
        self.circleFaceLayer.addSublayer(eyeslayer)
        return eyeslayer
    }()
    
    
    /// handler layer animation manager
    fileprivate lazy var animationManager: MHAnimationManager = { [unowned self] in
        let manager = MHAnimationManager(animationDuration: self.mhanimationDuration)
        return manager
    }()
    
    fileprivate var mhonColor: UIColor = UIColor(red: 74/255.0, green: 182/255.0, blue: 235/255.0, alpha: 1.0)
    
    fileprivate var mhoffColor: UIColor = UIColor(red: 211/255.0, green:207/255.0, blue:207/255.0, alpha: 1.0)
    
    fileprivate var mhfaceColor: UIColor = .white
    
    fileprivate var mhanimationDuration: CGFloat = 1.2
    
    fileprivate var mhisOn: Bool = false
    
    /// paddingWidth
    fileprivate var paddingWidth: CGFloat?
    
    /// face radius
    fileprivate var circleFaceRadius: CGFloat?
    
    /// the faceLayer move distance
    fileprivate var moveDistance: CGFloat?
    
    /// whether is animated
    fileprivate var isAnimating: Bool = false
    fileprivate var faceLayerWidth: CGFloat?
    
    
    
    // MARK: - Public Function
    open func setOn(isOn: Bool, animated: Bool) {
        
        if (mhisOn && isOn) || (!mhisOn && !isOn) { return }
        if animated {
            handleTapSwitch()
        }else {
            mhisOn = isOn
        }
    }
    
    
    // MARK: - Private Function
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        
        /// check the switch width and height
        assert(frame.size.width >= frame.size.height, "switch width must be tall!")

        paddingWidth = frame.size.height * 0.1
        circleFaceRadius = (frame.size.height - 2 * paddingWidth!) / 2
        faceLayerWidth = circleFaceLayer.frame.size.width
        moveDistance = frame.size.width - paddingWidth! * 2 - circleFaceRadius! * 2
        
        backgroundView.backgroundColor = mhoffColor
        circleFaceLayer.fillColor = mhfaceColor.cgColor
        eyesLayer.setNeedsDisplay()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapSwitch))
        addGestureRecognizer(tap)
    }
    
    
    @objc private func handleTapSwitch() {
        
        guard !isAnimating else { return }
        isAnimating = true
        
        // faceLayer
        let moveAnimation = animationManager.moveAnimation(fromPosition: circleFaceLayer.position, toPosition: mhisOn ? CGPoint(x: circleFaceLayer.position.x - moveDistance!, y: circleFaceLayer.position.y) : CGPoint(x: circleFaceLayer.position.x + moveDistance!, y: circleFaceLayer.position.y))
        moveAnimation.delegate = self
        circleFaceLayer.add(moveAnimation, forKey: MHSwitchKey.faceMove)
        
        // backfroundView
        let colorAnimation = animationManager.backgroundColorAnimation(fromValue: (mhisOn ? mhonColor : mhoffColor).cgColor, toValue: (mhisOn ? mhoffColor : mhonColor).cgColor)
        backgroundView.layer.add(colorAnimation, forKey: MHSwitchKey.backgroundColor)
        
        // eyesLayer
        let rotationAnimation = animationManager.eyeMoveAnimation(fromValue: 0, toValue: mhisOn ? -faceLayerWidth! : faceLayerWidth!)
        rotationAnimation.delegate = self
        eyesLayer.add(rotationAnimation, forKey: MHSwitchKey.eyesMoveStart)
        
        circleFaceLayer.masksToBounds = true
        
        if mhisOn {
            eyesKeyFrameAnimationStart()
        }

        // start delegate
        guard let delegate = delegate else { return }
        delegate.didTapMHSwitch?(mhSwitch: self)
    }
    
    deinit {
        delegate = nil
    }
}


// MARK: - add mouth keyFrameAnimation
extension MHSwitch {
    
    fileprivate func eyesKeyFrameAnimationStart() {
        let keyAnimation = animationManager.mouthKeyFrameAnimation(WidthOffSet: eyesLayer.frame.size.width, isOn: mhisOn)
        eyesLayer.add(keyAnimation, forKey: MHSwitchKey.mouthFrame)
    }
    
}


extension MHSwitch: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard flag else { return }
        
        // start eyes ending animation
        if anim == eyesLayer.animation(forKey: MHSwitchKey.eyesMoveStart) {
            eyesLayer.eyeColor = mhisOn ? mhoffColor : mhonColor
            eyesLayer.isLiking = !mhisOn
            eyesLayer.setNeedsDisplay()
            let rotationAnimation = animationManager.eyeMoveAnimation(fromValue: (mhisOn ? faceLayerWidth! : -faceLayerWidth!), toValue: (mhisOn ? -faceLayerWidth! / 6 : faceLayerWidth! / 6))
            rotationAnimation.delegate = self
            eyesLayer.add(rotationAnimation, forKey: MHSwitchKey.eyesMoveEnd)
            
            if !mhisOn {
                eyesKeyFrameAnimationStart()
            }
        }
        
        // start eyes back animation
        if anim == eyesLayer.animation(forKey: MHSwitchKey.eyesMoveEnd) {
            let rotationAnimation = animationManager.eyeMoveAnimation(fromValue: (mhisOn ? -faceLayerWidth! / 6 : faceLayerWidth! / 6), toValue: 0)
            rotationAnimation.delegate = self
            eyesLayer.add(rotationAnimation, forKey: MHSwitchKey.eyesMoveBack)
            
            if !mhisOn {
                let eyesKeyFrameAnimation = animationManager.eyesCloseAndOpenAnimation(rect: eyesLayer.eyeRect)
                eyesLayer.add(eyesKeyFrameAnimation, forKey: MHSwitchKey.eyesCloseAndOpen)
            }
        }
        
        // eyes back animation end
        if anim == eyesLayer.animation(forKey: MHSwitchKey.eyesMoveBack) {
            eyesLayer.mouthOffSet = mhisOn ? 0 : eyesLayer.frame.size.width
            
            if mhisOn {
                circleFaceLayer.position = CGPoint(x: circleFaceLayer.position.x - moveDistance!, y: circleFaceLayer.position.y)
                mhisOn = false
            }else {
                circleFaceLayer.position = CGPoint(x: circleFaceLayer.position.x + moveDistance!, y: circleFaceLayer.position.y)
                mhisOn = true
            }
            isAnimating = false
            
            // stop delegate
            guard let delegate = delegate else { return }
            delegate.animationDidStopForMHSwitch?(mhSwitch: self)
            
            // valueChanged
            delegate.valueDidChanged?(mhSwitch: self, isOn: mhisOn)
        }

    }
}


struct MHSwitchKey {
    
    static let faceMove         = "FaceMoveAnimationKey"
    static let backgroundColor  = "BackgroundColorAnimationKey"
    static let eyesMoveStart    = "EyesMoveStartAnimationKey"
    static let eyesMoveEnd      = "EyesMoveEndAnimationKey"
    static let eyesMoveBack     = "EyesMoveBackAnimationKey"
    static let mouthFrame       = "MouthFrameAnimationKey"
    static let eyesCloseAndOpen = "EyesCloseAndOpenAnimationKey"
}
