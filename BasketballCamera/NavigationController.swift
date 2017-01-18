//
//  NavigationController.swift
//  BasketballCamera
//
//  Created by 陳昱銘 on 2017/1/11.
//  Copyright © 2017年 Corn. All rights reserved.
//

import UIKit
import AVFoundation

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*let cameraview = cameraView(orientation: .portrait ,isBlur: true)
        view.addSubview(cameraview)
        view.sendSubview(toBack: cameraview)*/

    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

