//
//  GameViewController.swift
//  BasketballCamera
//
//  Created by 陳昱銘 on 2017/1/8.
//  Copyright © 2017年 Corn. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos


class GameViewController: UIViewController, AVCaptureFileOutputRecordingDelegate{
    
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    //视频输入设备
    let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    //音频输入设备
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    //将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()
    
    //保存所有的录像片段数组
    var videoAssets = [AVAsset]()
    //保存所有的录像片段url数组
    var assetURLs = [String]()
    
    //表示是否停止录像
    var stopRecording: Bool = false

    //剩余时间计时器
    var timer: Timer?
    var period: Int32 = 1
    var second: Int = 0
    //var sscPassed: String!
    var recording: Bool = true
    var recordButton: UIButton!
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var periodTime: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var guestScore: UILabel!
    
    @IBOutlet weak var unWhistleH1: UIImageView!
    @IBOutlet weak var unWhistleH2: UIImageView!
    @IBOutlet weak var unWhistleH3: UIImageView!
    @IBOutlet weak var unWhistleH4: UIImageView!
    @IBOutlet weak var unWhistleH5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        second = periodTime.tag*60
        
        //Turn to Landscape mode
        /*let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")*/
        
        //Hide NavigationBar
        //self.navigationController?.isNavigationBarHidden = true
        
        /*let cameraview = cameraView(orientation: .landscapeRight ,isBlur: false)
        view.addSubview(cameraview)
        view.sendSubview(toBack: cameraview)*/
        
        //添加视频、音频输入设备
        let videoInput = try! AVCaptureDeviceInput(device: self.videoDevice)
        self.captureSession.addInput(videoInput)
        let audioInput = try! AVCaptureDeviceInput(device: self.audioDevice)
        self.captureSession.addInput(audioInput);

        //添加视频捕获输出
        self.captureSession.addOutput(self.fileOutput)
            
        //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
        if let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) {
            videoLayer.frame = CGRect(x: 0, y: 0, width: 735, height: 375)
            videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoLayer.connection.videoOrientation = .landscapeRight

            recordView.layer.addSublayer(videoLayer)
            //self.view.layer.insertSublayer(videoLayer, above: self.view.layer)
            self.view.sendSubview(toBack: recordView)

        }
        
        //启动session会话
        self.captureSession.startRunning()
        
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscapeRight
    }
 
    
    @IBAction func recordTapped(_ sender: Any) {
     
        if(recording){
            if(!stopRecording) {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
                let documentsDirectory = paths[0] as String
                let outputFilePath = "\(documentsDirectory)/output-\(period).mov"
                period += 1
                let outputURL = URL(fileURLWithPath: outputFilePath)
                let fileManager = FileManager.default
                if(fileManager.fileExists(atPath: outputFilePath)) {
                    
                    do {
                        try fileManager.removeItem(atPath: outputFilePath)
                    } catch _ {
                    }
                }
                print("开始录制：\(outputFilePath) ")
                fileOutput.startRecording(toOutputFileURL: outputURL,
                                          recordingDelegate: self)
            }
            recordBtn.setTitle("碼表暫停 II", for: .normal)
            //timer?.invalidate()
            recording = false
        }
        else{
            fileOutput.stopRecording()
            recordBtn.setTitle("繼續錄製", for: .normal)
            recording = true
        }
        
    }
    
    //录像开始的代理方法
    func capture(_ captureOutput: AVCaptureFileOutput!,
                 didStartRecordingToOutputFileAt fileURL: URL!,
                 fromConnections connections: [Any]!) {
        startTimer()
    }
    
    //录像结束的代理方法
    func capture(_ captureOutput: AVCaptureFileOutput!,
                 didFinishRecordingToOutputFileAt outputFileURL: URL!,
                 fromConnections connections: [Any]!, error: Error!) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        print("生成视频片段：\(asset)")
        timer?.invalidate()
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        
    }
    
    //剩余时间计时器
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                      selector: #selector(GameViewController.counter),userInfo: nil,repeats:true)
    }
    
    //录制时间达到最大时间
    func counter() {
        print("color")
        second -= 1
        periodTime.text = String(format: "%02d",second/60)+":"+String(format: "%02d",second%60)
        if(second == 0){
            timer?.invalidate()
        }
    }

    @IBAction func saveVideo(_ sender: Any) {

        let composition = AVMutableComposition()
        //合并视频、音频轨道
        let firstTrack = composition.addMutableTrack(
            withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let audioTrack = composition.addMutableTrack(
            withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        var insertTime: CMTime = kCMTimeZero
        for asset in videoAssets {
            print("合并视频片段：\(asset)")
            do {
                try firstTrack.insertTimeRange(
                    CMTimeRangeMake(kCMTimeZero, asset.duration),
                    of: asset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                    at: insertTime)
            } catch _ {
            }
            do {
                try audioTrack.insertTimeRange(
                    CMTimeRangeMake(kCMTimeZero, asset.duration),
                    of: asset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                    at: insertTime)
            } catch _ {
            }
            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        //旋转视频图像，防止90度颠倒
        firstTrack.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        //获取合并后的视频路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0]
        let destinationPath = documentsPath + "/mergeVideo-\(arc4random()%1000).mov"
        print("合并后的视频：\(destinationPath)")
        let videoPath = URL(fileURLWithPath: destinationPath as String)
        let exporter = AVAssetExportSession(asset: composition,
                                            presetName:AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        //exporter.timeRange = CMTimeRangeMake(kCMTimeZero,CMTimeMakeWithSeconds(Float64(duration), framesPerSecond))
        exporter.exportAsynchronously(completionHandler: {
            //将合并后的视频保存到相册
            self.exportDidFinish(session: exporter)
        })

    }
    
    //将合并后的视频保存到相册
    func exportDidFinish(session: AVAssetExportSession) {
        print("视频合并成功！")
        let outputURL = session.outputURL!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async {
                //重置参数
                //self.reset()
                
                //弹出提示框
                let alertController = UIAlertController(title: "影片保存成功",message: "是否需要看影片？",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "确定",style: .default, handler: {
                    action in
                    //录像回看
                    self.reviewRecord(outputURL: outputURL)
                })
                let cancelAction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true,completion: nil)
            }
        })
    }
    
    //录像回看
    func reviewRecord(outputURL: URL) {
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: outputURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    @IBAction func scoreTapping(_ sender: UIButton) {
        sender.alpha = 1.0
    }
    @IBAction func scoreTapped(_ sender: UIButton) {
        
        var hScore:Int = Int(homeScore.text!) ?? 0
        var gScore:Int = Int(guestScore.text!) ?? 0
        
        switch sender.tag {
        case 10:
            hScore -= 1
        case 11:
            hScore += 1
        case 20:
            gScore -= 1
        case 21:
            gScore += 1
        default:
            fatalError("Unknown operator button: \(sender)")
        }
        homeScore.text = String(hScore)
        guestScore.text = String(gScore)
        sender.alpha = 0.4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
