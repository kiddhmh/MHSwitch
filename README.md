# MHSwitch 
动画效果的开关;
==================

This is a funny switch for iOS<br>

Thank [lilei644](https://github.com/lilei644) for providing inspiration

----------


Preview  预览
-------------
![MHSwitchDemo](https://github.com/kiddhmh/MHSwitch/blob/master/PreView/MHSwitchDemo.gif)

## Installation &nbsp;
```Swift

```
* Common
``` Swift
Add "MHSwitch" files to your Project   // 直接导入“MHSwitch”文件夹到项目中 (后面会支持cocoaPod和carthge导入)
```

## Usage &nbsp;用法
* Init &nbsp;初始化
``` Swift
let mhSwitch = MHSwitch.init(frame: CGRect(x: 100, y: 100, width: 120, height: 60))
view.addSubview(mhSwitch)
```
* Reset Base Property &nbsp;重设基本属性
``` Swift
mhSwitch.onColor = .blue    // switch is open color   开关打开的颜色
mhSwitch.offColor = .gray    // switch is close color    开关关闭的颜色
mhSwitch.faceColor = .whiteColor    // switch face color    圆脸的颜色
mhSwitch.animationDuration = 1.2    // switch open or close animation time    开关的动画时间

mhSwitch.isOn = true                     // set on and off     设置开关
mhSwitch.setOn(isOn: true, animated: true)
```

* delegate &nbsp;代理监听
``` Switf
mhSwitch.delegate = self

func valueDidChanged(mhSwitch: MHSwitch, isOn: Bool) {
        print("stop\(isOn)")
    }
    
func didTapMHSwitch(mhSwitch: MHSwitch) {
        print("didStart")
    }
    
func animationDidStopForMHSwitch(mhSwitch: MHSwitch) {
        print("didStop")
    }
```
* support xib and storyboard&nbsp;支持xib和storyboard
![MHSwitchForXib](https://github.com/kiddhmh/MHSwitch/blob/master/PreView/MHSwitchDemo.png)

