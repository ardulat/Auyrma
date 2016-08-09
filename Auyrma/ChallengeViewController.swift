//
//  ChallengeViewController.swift
//  Auyrma
//
//  Created by MacBOOK PRO on 08.08.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func photoLibraryButtonTapped(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageCLicked = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("SeguePhotoLibrary", sender: imageCLicked)})
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SeguePhotoLibrary" {
            let shareVC = segue.destinationViewController as! ShareViewController
            shareVC.defaultImage = sender as? UIImage
        }
    }
}