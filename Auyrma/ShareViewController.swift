//
//  ShareViewController.swift
//  Auyrma
//
//  Created by MacBook on 05.08.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import Photos

class ShareViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    var defaultImage: UIImage? = nil
    var documentController: UIDocumentInteractionController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var overlayImageView: UIImageView!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = defaultImage else {
            return
        }
        
        self.imageView.image = image
        self.imageView.contentMode = .ScaleAspectFill
        
        let subimage1 = UIImage(named: "overlay")
        self.overlayImageView.image = subimage1
        self.imageView.clipsToBounds = true
        
    }
    
    @IBAction func shareButton(sender: UIButton) {
        self.shareToInstagram()
        _ = self.imageView.image!
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject as? PHAsset {
            let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            _ = NSURL(string: u)!
        }
    }
    
    // MARK: - Make Screenshot of ImageView

    class func screenshot(view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - Share photo to Instagram
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        return
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
    func shareToInstagram() {

        container.addSubview(imageView)
        container.addSubview(overlayImageView)
        let screenShot = ShareViewController.screenshot(container)
        
        let instagramURL = NSURL(string: "instagram://app")
        
        if (UIApplication.sharedApplication().canOpenURL(instagramURL!)) {
            
            let imageData = UIImageJPEGRepresentation(screenShot, 100)
            
            let captionString = "caption"
            
            let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("instagram.jpg")
            if imageData?.writeToFile(writePath, atomically: true) == false {
                
                return
                
            } else {
                let fileURL = NSURL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(URL: fileURL)
                
                self.documentController.delegate = self
                
                self.documentController.UTI = "com.instagram.exlusivegram"
                
                self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption")
                self.documentController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
                
            }
            
        } else {
            print(" Instagram isn't installed ")
        }
    }
}
