//
//  CameraViewController.swift
//  Auyrma
//
//  Created by MacBook on 05.08.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var previewView: UIView!
    var overlayImageView = UIImageView()

    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var counter: Int = 1
    
    var mainImage: UIImage? = nil
    
    var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera(counter)
    }
    
    private func setUpCamera(num: Int) {
        self.counter = num
        
        self.previewView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.width))
        self.view.addSubview(previewView)
        
        if session != nil {
            session?.stopRunning()
        }
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        if num == 2 {
            let devices: NSArray = AVCaptureDevice.devices()
            for de in devices {
                let deviceConverted = de as! AVCaptureDevice
                if(deviceConverted.position == .Front) {
                    backCamera = deviceConverted
                }
                if(deviceConverted.position == .Back) {
                    backCamera = deviceConverted
                }
            }
        }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
        }
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if session!.canAddOutput(stillImageOutput) {
            session!.addOutput(stillImageOutput)
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
        
        previewView.contentMode = .ScaleAspectFill
        previewView.layer.addSublayer(videoPreviewLayer!)
        session!.startRunning()
        videoPreviewLayer!.frame = previewView.bounds
        
        
        let subimage1 = UIImage(named: "overlay")
        self.overlayImageView.image = subimage1
        overlayImageView.frame = previewView.bounds
        previewView.addSubview(overlayImageView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
    }
    
    @IBAction func changeCamera(sender: UIButton) {
        self.setUpCamera(3 - counter)
    }
    
    
    @IBAction func didTakePhoto(sender: UIButton) {
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            // ...
            // Code for photo capture goes here...
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                // ...
                // Process the image data (sampleBuffer) here to get an image file we can put in our captureImageView
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    var image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
//                    if self.backCamera.position == .Front {
//                        let flippedImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.LeftMirrored)
//                        image = flippedImage
//                    }
                    
                    self.mainImage = image
                    self.performSegueWithIdentifier("SegueCaptured", sender: nil)
                    // ...
                    // Add the image to captureImageView here...
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueCaptured" {
            let vc = segue.destinationViewController as! ShareViewController
            vc.defaultImage = self.mainImage
        }
    }
}




