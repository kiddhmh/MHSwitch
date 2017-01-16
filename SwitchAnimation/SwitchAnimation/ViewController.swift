//
//  ViewController.swift
//  SwitchAnimation
//
//  Created by 胡明昊 on 17/1/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var subLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mhSwitch = MHSwitch.init(frame: CGRect(x: 100, y: 100, width: 120, height: 60))
        view.addSubview(mhSwitch)
        mhSwitch.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: MHSwitchDelegate {
    
    func valueDidChanged(mhSwitch: MHSwitch, isOn: Bool) {
        print("stop\(isOn)")
    }
    
    func didTapMHSwitch(mhSwitch: MHSwitch) {
        print("didStart")
    }
    
    func animationDidStopForMHSwitch(mhSwitch: MHSwitch) {
        print("didStop")
    }
}

