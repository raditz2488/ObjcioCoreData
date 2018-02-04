//
//  CameraView.swift
//  Moody
//
//  Created by pranav on 03/02/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit
import AVFoundation


class CameraView: UIView {
    
    @IBOutlet weak var label: UILabel!
    
    var authorized: Bool = false {
        didSet {
            label.text = authorized ? localized(.cameraView_tapToCapture) : localized(.cameraView_needAccess)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(for previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer = previewLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
    
    // MARK: Private
    
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    
    fileprivate func setup() {
        backgroundColor = UIColor.black
    }
    
    
}
