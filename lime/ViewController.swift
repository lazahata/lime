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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        mainView = MainView()
        if let mainView = mainView {
            mainView.frame = UIScreen.main.bounds
            self.view.addSubview(mainView)
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
        
        let device = AVCaptureDevice.default(for: .video)
        if let device = device {
            do {
                try device.lockForConfiguration()
//                let minDuration = device.activeFormat.minExposureDuration
//                let maxDuration = device.activeFormat.maxExposureDuration
                let duration = CMTimeMake(value: 1, timescale: 1500)
//                if (duration < minDuration) { duration = minDuration }
//                if (duration > maxDuration) { duration = maxDuration }
                device.setFocusModeLocked(lensPosition: 1) { CMTime in }
                device.setExposureModeCustom(duration: duration, iso: device.activeFormat.maxISO) { CMTime in }
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
}
