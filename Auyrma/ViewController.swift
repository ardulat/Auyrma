//
//  ViewController.swift
//  Auyrma
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SCLAlertView
import NVActivityIndicatorView
import RealmSwift
import DropDown
import Firebase

class ViewController: UIViewController {
    
    
    let tutorialText = ["Приложение Auyrma помогает находить вам аналоги медикаментов. При поиске аналогов приложение выдает возможные аналоги.", "Напоминания помогут вам соблюдать режим приема медикаментов для лучшего результата."]
    let tutorialTitle = ["Ознакомление", "Напоминания"]
    let tutorialButton = ["Далее", "Завершить"]
    
    @IBOutlet weak var qwerty: UILabel!
    
    let myColor : UIColor = UIColor( red: 185/255, green: 60/255, blue:60/255, alpha: 1.0 )
    
    @IBOutlet weak var textField: UITextField!
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 2, height: 2), type: NVActivityIndicatorType(rawValue: 12)!, color: UIColor.redColor(), padding: 0)
    
    
    let dropDown = DropDown()
    var tempPrefix = [""]
    
    
    override func viewDidLoad() {
        
        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: -20, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 14)!, color: self.myColor, padding: 0)
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3.0)
        self.view.addSubview(self.activityIndicator)
        
        super.viewDidLoad()
        
        
        self.textField.addTarget(self, action: #selector(ViewController.editingBegin), forControlEvents: UIControlEvents.EditingDidBegin)
        self.textField.addTarget(self, action: #selector(ViewController.searchChanged), forControlEvents: UIControlEvents.EditingChanged)
        
        self.textField.autocorrectionType = .No
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.qwerty.text = "Auyrma - первое бесплатное Казахстанское приложение, которое помогает сэкономить на дорогих лекарствах, предоставляя вам список их более дешевых аналогов. "
        
        
        self.dropDown.anchorView = self.textField
        self.dropDown.selectionBackgroundColor = self.myColor
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if self.dropDown.dataSource.first! != "поиск не дал результатов =(" {
                self.textField.text = self.dropDown.dataSource[index]
                self.performSegueWithIdentifier("SegueSearchAnalog", sender: nil)
            } else {
                self.textField.text = ""
            }
        }
        
        self.dropDown.bottomOffset = CGPoint(x: 0, y:self.textField.frame.height + 20)
        
        self.activityIndicator.startAnimation()
        
        guard NSUserDefaults.standardUserDefaults().valueForKey("firstEnter") != nil else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstEnter")
            // downloading all pill names in first user interaction
            
            self.qwerty.text = "загрузка таблеток"
            self.textField.textColor = self.myColor
            self.downloadPrefixesFromFirebaseToRealm()
            self.showTutorial(0)
            return
        }
        self.activityIndicator.stopAnimation()
    }
    
    func downloadPrefixesFromFirebaseToRealm() {
        let ref = FIRDatabase.database().reference().child("byName")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            let realm = try! Realm()
            for (a, b) in snap.value as! [String: AnyObject] {
                guard let word = b["name"] as? String else {
                    continue
                }
                try! realm.write {
                    let temp = Prefix()
                    temp.name = word
                    realm.add(temp)
                }
                //print("all")
            }
            self.textField.text = ""
            self.qwerty.text = "Auyrma - первое бесплатное Казахстанское приложение, которое помогает сэкономить на дорогих лекарствах, предоставляя вам список их более дешевых аналогов. "
            self.textField.placeholder = "введите название лекарства"
            self.activityIndicator.stopAnimation()
        }
    }
    
    func editingBegin() {
        print("test")
    }
    
    func searchChanged() {
        let word = self.textField.text!.lowercaseString
        let length = word.characters.count
        
        
        if length >= 3 {
            self.tempPrefix.removeAll()
            let realm = try! Realm()
            let result = Array(realm.objects(Prefix.self).filter("name CONTAINS '\(word)'"))
            for temp in result {
                self.tempPrefix.append(temp.name!)
            }
            self.dropDown.dataSource = self.tempPrefix
            self.dropDown.reloadAllComponents()
            self.dropDown.show()
        }
    }
    
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCloseButton: false
    )
    
    func showTutorial(i: Int) {
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: self.appearance)
        
        // Add Button with Duration Status and custom Colors
        if i < self.tutorialText.count {
            alert.addButton(self.tutorialButton[i], backgroundColor: self.UIColorFromRGB(0xB40431), textColor: UIColor.whiteColor(), showDurationStatus: true) {
                self.showTutorial(i + 1)
            }
            
            alert.showInfo(self.tutorialTitle[i], subTitle: self.tutorialText[i])
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        textField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueSearchAnalog" {
            let vc = segue.destinationViewController as! AnalogResultViewController
            vc.titleText = self.textField.text!
            vc.title = self.textField.text!.capitalizedString
        }
    }
}

