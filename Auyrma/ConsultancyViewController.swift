//
//  ConsultancyViewController.swift
//  Auyrma
//
//  Created by MacBook on 20.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import MessageUI

class ConsultancyViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
   
    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        self.nameTextField.layer.borderColor = UIColor.redColor().CGColor
        self.phoneTextField.layer.borderColor = UIColor.redColor().CGColor
        self.questionTextField.layer.borderColor = UIColor.redColor().CGColor
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let myColor : UIColor = UIColor( red: 185/255, green: 60/255, blue:60/255, alpha: 1.0 )
       
        questionTextField.layer.masksToBounds = true
        questionTextField.layer.cornerRadius = 8.0
        questionTextField.layer.borderColor = myColor.CGColor
        questionTextField.layer.borderWidth = 1.0
        
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.layer.borderColor = myColor.CGColor
        nameTextField.layer.borderWidth = 1.0
        
        phoneTextField.layer.masksToBounds = true
        phoneTextField.layer.cornerRadius = 8.0
        phoneTextField.layer.borderColor = myColor.CGColor
        phoneTextField.layer.borderWidth = 1.0
        sendButton.backgroundColor = myColor
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        
        if self.phoneTextField.text == nil && self.phoneTextField.text?.characters.count < 10 {
            self.phoneTextField.placeholder = "Напишите заявку..."
            return
        }
        
        
        if self.questionTextField.text == nil && self.questionTextField.text == "" {
            return
        }
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["mademihanov.erzhan@gmail.com"])
        mailComposerVC.setSubject("Заявка на консультацию. \(self.nameTextField.text)")
        mailComposerVC.setMessageBody("Заявка на консультацию. Вопрос: \(self.questionTextField.text) \n\n Контактные данные: \n Телефон: \(self.phoneTextField.text)", isHTML: false)
        
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
        
}
    
    
    



