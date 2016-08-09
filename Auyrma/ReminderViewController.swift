//
//  ReminderViewController.swift
//  Auyrma
//
//  Created by MacBook on 09.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

protocol WeekdayDelegate {
    func updateWeekdays(weekdays: [Bool])
}

class ReminderViewController: UIViewController, WeekdayDelegate {

    
    var appDelegate: AppDelegate?
    var weekdays = [true, true, true, true, true, true, true]
    var dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var placeHolder: String = "Выпить таблетку"
    
    let myColor : UIColor = UIColor( red: 185/255, green: 60/255, blue:60/255, alpha: 1.0 )
    let addButtonColor : UIColor = UIColor(red: 88/255, green: 142/255, blue: 183/255, alpha: 1.0)
    
    
    @IBOutlet weak var notificationTitle: UITextField!
    
    @IBOutlet weak var notificationTime1: UIDatePicker!
    
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.notificationTitle.placeholder = self.placeHolder
        self.saveButtonOutlet.backgroundColor = self.myColor
        self.notificationTitle.layer.borderColor = myColor.CGColor
        print(self.placeHolder)
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        var reminderTitle = self.placeHolder
        
        if self.notificationTitle.text != nil && self.notificationTitle.text != "" {
            reminderTitle = self.notificationTitle.text!
        }
        
        print("\n\n#########")
        print(reminderTitle)
        print("#########\n\n")
        
        self.saveTime("\(reminderTitle)", date: self.notificationTime1.date)
        
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        // Add Button with Duration Status and custom Colors
        alert.addButton("Ок", backgroundColor: self.UIColorFromRGB(0xB93C3C), textColor: UIColor.whiteColor(), showDurationStatus: true) {
            print("Duration Button tapped")
        }
        
        alert.showInfo("Сохранено", subTitle: "")
    }
    
    func saveTime(title: String, date: NSDate) {
        self.notificationTime1.timeZone = NSTimeZone.defaultTimeZone()
        
        let notification:UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = title
        notification.fireDate = date
        notification.repeatInterval = .Day
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.userInfo = ["uid": title]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        print(notification)
        let reminder = Reminder()
        reminder.title = title
        reminder.notificationId = "456"
        reminder.date = date
        self.create(reminder)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    // DELEGATE functions
    
    func updateWeekdays(weekdays: [Bool]) {
        self.weekdays = weekdays
        print(self.weekdays)
    }

    
    // MARK: Reminders Functions
    
    func create(reminder: Reminder) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(reminder)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueWeekdays" {
            let vc = segue.destinationViewController as!PickDaysViewController
            vc.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
