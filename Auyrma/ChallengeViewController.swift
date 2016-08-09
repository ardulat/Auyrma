//
//  ChallengeViewController.swift
//  Auyrma
//
//  Created by MacBOOK PRO on 08.08.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit

protocol WordsIndexDelegate {
    func didUpdatePageIndex(index: Int)
}

class ChallengeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WordsIndexDelegate {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var words = ["Ayurma - за доступный здоровый образ жизни для каждого казахстанца",
                 "Присоединяйся и выставляй своё спортивное фото в поддержку сборной Казахстана в Рио",
                 "Отмечай фото хештегом #algakzrio2016 и не забудь передать эстафету 7 друзьям",
                 "Лучшие фото попадут на страницу @auyrma_app в инстаграм!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = words.count
    }
    
    // MARK: - Container and Page Control
    
    func didUpdatePageIndex(index: Int) {
        self.pageControl.currentPage = index
    }
    
    // MARK: - Camera and Photo Library
    
    @IBAction func photoLibraryButtonTapped(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
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
        
        if let wordsPVC = segue.destinationViewController as? PageViewController {
            wordsPVC.words = self.words
            wordsPVC.wordsDelegate = self
        }

    }
    
}