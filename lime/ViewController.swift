//
//  ViewController.swift
//  lime
//
//  Created by dzzhang on 2023/2/27.
//

import UIKit

class ViewController: UIViewController {
    
    var mainView: MainView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = MainView()
        mainView?.videoPreviewLayer.session =
        self.view.addSubview(mainView)
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
        
    }

}

