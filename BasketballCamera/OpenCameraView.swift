//
//  OpenCameraView.swift
//  BasketballCamera
//
//  Created by 陳昱銘 on 2017/1/11.
//  Copyright © 2017年 Corn. All rights reserved.
//

import UIKit
import AVFoundation

struct ScreenSize{
    var Width : CGFloat = 375
    var Height : CGFloat = 735
}

func cameraView(orientation:AVCaptureVideoOrientation, isBlur:Bool) -> UIView{
    
    var screenSize = ScreenSize()
    if orientation == .landscapeRight {
        //Bad Solution
        screenSize.Width = 735
        screenSize.Height = 375
    }
    
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.Width, height: screenSize.Height))
    var session : AVCaptureSession?
    var captureVideoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    session = AVCaptureSession()
    session?.sessionPreset = AVCaptureSessionPresetMedium
    
    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let input = try! AVCaptureDeviceInput(device: device)
    session?.addInput(input)
 //   let output = AVCaptureVideoDataOutput()
 //   session?.addOutput(output)
        
    captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
    captureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    captureVideoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: screenSize.Width, height: screenSize.Height)
    if(orientation == .landscapeRight){
        captureVideoPreviewLayer?.connection.videoOrientation = .landscapeRight
    }
    
    
    view.layer.addSublayer(captureVideoPreviewLayer!)
    session?.startRunning()
    
    if(isBlur == true){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    return view
    
}

