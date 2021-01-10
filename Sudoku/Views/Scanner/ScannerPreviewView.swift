//
//  ScannerPreviewView.swift
//  Sudoku
//
//  Created by Logan Richards on 1/10/21.
//  Copyright © 2021 ZER0 Tech. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerPreviewView: UIView {
	
	var videoPreviewLayer: AVCaptureVideoPreviewLayer {
		guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
			fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check ScannerPreviewView.layerClass implementation.")
		}
		
		return layer
	}
	
	var session: AVCaptureSession? {
		get {
			return self.videoPreviewLayer.session
		}
		
		set {
			self.videoPreviewLayer.session = newValue
		}
	}
	
	override class var layerClass: AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
	
}
