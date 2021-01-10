//
//  ScannerViewController.swift
//  Sudoku
//
//  Created by Logan Richards on 1/10/21.
//  Copyright © 2021 ZER0 Tech. All rights reserved.
//

import UIKit
import AVFoundation

final class ScannerViewController: UIViewController {
	//MARK: - UI objects
	var previewView: ScannerPreviewView!
	var cutoutView: UIView!
	var numberView: UILabel!
	
	var maskLayer = CAShapeLayer()
	
	//Device orientation. Updated whenever the orientation changes to a different supported orientation.
	var currentOrientation = UIDeviceOrientation.portrait
	
	//MARK: - Capture related objects
	private let captureSession = AVCaptureSession()
	let captureSessionQueue = DispatchQueue(label: "com.logarithm.Sudoku.Sacnner.CaptureSessionQueue")
	
	var captureDevice: AVCaptureDevice?
	
	var videoDataOutput = AVCaptureVideoDataOutput()
	let videoDataOutputQueue = DispatchQueue(label: "com.logarithm.Sudoku.Sacnner.VideoDataOutputQueue")
	
	//MARK: - Region of interest (ROI) and text orientation
	//Region of video data output buffer that recognititon should be run on.
	//Gets recaluculatedx once the bounds of the preview layer are known.
	var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
	
	//Orientation of text to search for in the region of interest.
	var textOrientation = CGImagePropertyOrientation.up
	
	//MARK: - Coordinate transforms
	var bufferAspectRatio: Double!
	
	//Transform from UI orientation to buffer orientation.
	var uiRotationTransform = CGAffineTransform.identity
	
	//Transform botttom-left coordinates to top-left.
	var bottomToTopTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
	
	//Transform coordinates in ROI to global coordinates (still normalized).
	var roiToGlobalTransform = CGAffineTransform.identity
	
	//Vision -> AVF coordinate transform.
	var visionToAVFTransform = CGAffineTransform.identity
	
	//MARK: - View Controller Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
		
		//Set Up Views
		self.previewView = ScannerPreviewView(frame: CGRect(x: 0.0, y: 0.0, width: 414.0, height: 896.0))
		self.view.addSubview(self.previewView)
		
		self.previewView.translatesAutoresizingMaskIntoConstraints = false
		let previewView_centerXConstraint = NSLayoutConstraint(item: self.previewView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
		let previewView_centerYConstraint = NSLayoutConstraint(item: self.previewView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
		let previewView_traillingSpaceConstraint = NSLayoutConstraint(item: self.previewView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
		let previewView_bottomSpaceConstraint = NSLayoutConstraint(item: self.previewView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
		self.view.addConstraints([previewView_centerXConstraint, previewView_centerYConstraint, previewView_bottomSpaceConstraint, previewView_traillingSpaceConstraint])
		
		self.cutoutView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 414.0, height: 896.0))
		self.view.addSubview(self.cutoutView)
		
		self.cutoutView.translatesAutoresizingMaskIntoConstraints = false
		let cutoutView_centerXConstraint = NSLayoutConstraint(item: self.cutoutView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
		let cutoutView_centerYConstraint = NSLayoutConstraint(item: self.cutoutView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
		let cutoutView_traillingSpaceConstraint = NSLayoutConstraint(item: self.cutoutView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
		let cutoutView_bottomSpaceConstraint = NSLayoutConstraint(item: self.cutoutView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
		self.view.addConstraints([cutoutView_centerXConstraint, cutoutView_centerYConstraint, cutoutView_bottomSpaceConstraint, cutoutView_traillingSpaceConstraint])
		
		self.numberView = UILabel(frame: CGRect(x: 116.5, y: 430.5, width: 181, height: 35))
		self.numberView.font = UIFont(name: "Menlo", size: 30.0)
		self.numberView.isHidden = true
		self.numberView.baselineAdjustment = .alignBaselines
		self.numberView.lineBreakMode = .byTruncatingTail
		self.view.addSubview(self.numberView)
		
		self.numberView.translatesAutoresizingMaskIntoConstraints = false
		let numberView_centerXConstraint = NSLayoutConstraint(item: self.numberView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
		let numberView_centerYConstraint = NSLayoutConstraint(item: self.numberView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
		self.view.addConstraints([numberView_centerXConstraint, numberView_centerYConstraint])
		
		//Set Up preview view
		self.previewView.session = self.captureSession
		
		//Set up cutout view.
		self.cutoutView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
		self.maskLayer.backgroundColor = UIColor.clear.cgColor
		self.maskLayer.fillRule = .evenOdd
		self.cutoutView.layer.mask = self.maskLayer
		
		//Starting the capture session is a blocking call. Perform setup using a dedicated serial dispatch queue to prevent blocking the main thread
		self.captureSessionQueue.async {
			self.setupCamera()
			
			//Calculate region of interest now that the camera is setup.
			DispatchQueue.main.async {
				//Figure out initial ROI.
				self.calculateRegionOfInterest()
			}
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		//Only change the current orientation if the new one is landscape or portrait. You can't really do anything about flat or unknown.
		let deviceOrientation = UIDevice.current.orientation
		if(deviceOrientation.isPortrait || deviceOrientation.isLandscape) {
			self.currentOrientation = deviceOrientation
		}
		
		//Handle device orientation in the preview layer.
		if let videoPreviewLayerConnection = self.previewView.videoPreviewLayer.connection {
			if let newVideoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation) {
				videoPreviewLayerConnection.videoOrientation = newVideoOrientation
			}
		}
		
		// Orientation changed: figure out new region of interest (ROI).
		self.calculateRegionOfInterest()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateCutout()
	}
	
	//MARK: - Setup
	
	func calculateRegionOfInterest() {
		//In landscape orientation the desired ROI is specified as the ratio of buffer width to height. When the UI is rotated to portrait, keep the vertical size the same (in buffer pixels). Also try to keep the horizontal size the same up to a maximun ratio.
		let desiredHeightRatio = 0.4
		let desiredWidthRatio = 0.6
		let maxPortraitWidth = 0.8
		
		//Figure out size of ROI
		let size: CGSize
		if(currentOrientation.isPortrait || self.currentOrientation == .unknown) {
			size = CGSize(width: min(desiredWidthRatio * self.bufferAspectRatio, maxPortraitWidth), height: desiredHeightRatio / self.bufferAspectRatio)
		} else {
			size = CGSize(width: desiredWidthRatio, height: desiredHeightRatio)
		}
		
		//Make it centered.
		self.regionOfInterest.origin = CGPoint(x: (1 - size.width) / 2, y: (1 - size.height) / 2)
		self.regionOfInterest.size = size
		
		//ROI changed, update transform.
		self.setupOrientationAndTransform()
		
		//Update the cutout to match the new ROI.
		DispatchQueue.main.async {
			//Wait for the next run cycle before updating the cutout. This ensures that the preview layer has its new orientation.
			self.updateCutout()
		}
		
	}
	
	func updateCutout() {
		//Figure out where the cutout endsup in layer coordinates.
		let roiRectTransform = self.bottomToTopTransform.concatenating(self.uiRotationTransform)
		let cutout = self.previewView.videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: self.regionOfInterest.applying(roiRectTransform))
		
		//Create the mask.
		let path = UIBezierPath(rect: self.cutoutView.frame)
		path.append(UIBezierPath(rect: cutout))
		self.maskLayer.path = path.cgPath
		
		//Move the number view down to under cutout.
		var numFrame = cutout
		numFrame.origin.y += numFrame.size.height
		self.numberView.frame = numFrame
	}
	
	
	func setupOrientationAndTransform() {
		//Recalculate the affine transform between Vision coordinates and AVF coordinates.
		
		//Compensate for region of interest
		let roi = self.regionOfInterest
		self.roiToGlobalTransform = CGAffineTransform(translationX: roi.origin.x, y: roi.origin.y).scaledBy(x: roi.width, y: roi.height)
		
		//Compensate for orientation (bufferes always come in the same orientation).
		switch self.currentOrientation {
		case .landscapeLeft:
			self.textOrientation = CGImagePropertyOrientation.up
			self.uiRotationTransform = CGAffineTransform.identity
		case .landscapeRight:
			self.textOrientation = CGImagePropertyOrientation.down
			self.uiRotationTransform = CGAffineTransform(translationX: 1, y: 1).rotated(by: CGFloat.pi)
		case .portraitUpsideDown:
			self.textOrientation = CGImagePropertyOrientation.left
			self.uiRotationTransform = CGAffineTransform(translationX: 1, y: 1).rotated(by: CGFloat.pi / 2)
		default: //We default everything elese to .portraitUp
			self.textOrientation = CGImagePropertyOrientation.right
			self.uiRotationTransform = CGAffineTransform(translationX: 1, y: 1).rotated(by: -CGFloat.pi / 2)
		}
		
		//Full Vision ROI to AVF transform.
		self.visionToAVFTransform = self.roiToGlobalTransform.concatenating(self.bottomToTopTransform).concatenating(self.uiRotationTransform)
	}
	
	func setupCamera() {
		guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
			print("Could not create capture device.")
			return
		}
		
		self.captureDevice = captureDevice
		
		//NOTE: Requesting 4k buffers allows recognition of smaller text but will consume more power. Use the smallest buffer size necessary to keep down battery usage.
		if captureDevice.supportsSessionPreset(.hd4K3840x2160) {
			self.captureSession.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
			self.bufferAspectRatio = 3840.0 / 2160.0
		} else {
			self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
			self.bufferAspectRatio = 1920.0 / 1080.0
		}
		
		guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
			print("Could not create device input.")
			return
		}
		
		if self.captureSession.canAddInput(deviceInput) {
			self.captureSession.addInput(deviceInput)
		}
		
		//Configure video data output.
		self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
		self.videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)
		self.videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
		
		if self.captureSession.canAddOutput(self.videoDataOutput) {
			self.captureSession.addOutput(self.videoDataOutput)
			
			//NOTE: There is a trade-off to be made here. Enabling stabilization will give temporally more stable results and should help the recognizer converge. But if it's enabled the VideoDataOutput buffers don't match what's displayed on screen, which makes drawing bounding boxes very hard. Disable it in this app to allow drawing detected bounding boxes on screen.
			self.videoDataOutput.connection(with: AVMediaType.video)?.preferredVideoStabilizationMode = .off
		} else {
			print("Could not add VDO output")
			return
		}
		
		//Set zoom and autofocus to help focus on very small text.
		do {
			try captureDevice.lockForConfiguration()
			captureDevice.videoZoomFactor = 2
			captureDevice.autoFocusRangeRestriction = .near
			captureDevice.unlockForConfiguration()
		} catch {
			print("Could not set zoom level due to error: \(error)")
			return
		}
		
		captureSession.startRunning()
	}
	
	//MARK: - UI drawing and interation
	
	func showString(string: String) {
		//Found a definite number.
		//Stop the camera synchronously to ensure that no further buffers are received. Then update the number view asynchronously.
		self.captureSessionQueue.sync {
			self.captureSession.stopRunning()
			
			DispatchQueue.main.async {
				self.numberView.text = string
				self.numberView.isHidden = false
			}
		}
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		self.captureSessionQueue.async {
			if(!self.captureSession.isRunning) {
				self.captureSession.startRunning()
			}
			
			DispatchQueue.main.async {
				self.numberView.isHidden = true
			}
		}
	}
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ScannerViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
	
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		// This is implemented in VisionViewController.
	}
	
}


//MARK: - Utility extensions

extension AVCaptureVideoOrientation {
	public init?(deviceOrientation: UIDeviceOrientation) {
		switch deviceOrientation {
		case .portrait: self = .portrait
		case .portraitUpsideDown: self = .portraitUpsideDown
		case .landscapeLeft: self = .landscapeRight
		case .landscapeRight: self = .landscapeLeft
		default: return nil
		}
	}
}
