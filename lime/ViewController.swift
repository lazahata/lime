//
//  ViewController.swift
//  lime
//
//  Created by dzzhang on 2023/2/27.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var mainView: MainView? = nil
    var device: AVCaptureDevice? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        mainView = MainView()
        if let mainView = mainView {
            mainView.frame = UIScreen.main.bounds
            self.view.addSubview(mainView)
            setUpSlider()
        }
        Task {
            await setUpCaptureSession()
        }
    }
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            if (status == .notDetermined) {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
    }
    
    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
        let captureSession = AVCaptureSession()
        
        device = AVCaptureDevice.default(for: .video)
        if let device = device {
            do {
                try device.lockForConfiguration()
                let duration = device.activeFormat.minExposureDuration
                device.setExposureModeCustom(duration: duration, iso: device.activeFormat.maxISO) { CMTime in }
                device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                device.unlockForConfiguration()
                guard
                    let videoDeviceInput = try? AVCaptureDeviceInput(device: device), captureSession.canAddInput(videoDeviceInput)
                else { return }
                captureSession.beginConfiguration()
                captureSession.addInput(videoDeviceInput)
                mainView?.videoPreviewLayer.session = captureSession
                captureSession.commitConfiguration()
                DispatchQueue.global().async {
                    captureSession.startRunning()
                }
            } catch {}
        }
    }
    
    func setUpSlider() {
        let slider = UISlider()
        slider.frame = CGRect(x: 30, y: self.view.bounds.height * 2 / 3, width: self.view.bounds.width - 60, height: 60)
        slider.addTarget(self, action: #selector(xxx), for: UIControl.Event.valueChanged)
        self.view.addSubview(slider)
    }
    
    @objc func xxx(slider: UISlider) {
        if let device = device {
            do {
                try device.lockForConfiguration()
                let minDuration = device.activeFormat.minExposureDuration
                let value = minDuration.value + minDuration.value * Int64(slider.value * 100)
                let myDuration = CMTimeMake(value: value, timescale: minDuration.timescale)
                print(myDuration)
                device.setExposureModeCustom(duration: myDuration, iso: device.activeFormat.maxISO) { CMTime in
                }
                device.unlockForConfiguration()
            } catch {}
        }
    }
}

