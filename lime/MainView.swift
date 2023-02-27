//
//  MainView.swift
//  lime
//
//  Created by dzzhang on 2023/2/27.
//

import Foundation
import UIKit
import AVFoundation

class MainView : UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
