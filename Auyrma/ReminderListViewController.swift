//
//  ReminderListViewController.swift
//  Auyrma
//
//  Created by MacBook on 15.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import RealmSwift

class ReminderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var myReminders = [Reminder]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.loadRemindersLocally()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.myReminders.removeAll()
        self.loadRemindersLocally()
    }
    
    func deleteReminder(index: Int) {
        let reminder = self.myReminders[index]
        
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
       
        for oneEvent in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            
            guard let userInfo = notification.userInfo as? [String: AnyObject] else {
                continue
            }
            
            guard let keyWord = userInfo["uid"] as? String else {
                continue
            }
            
            if self.myReminders[index].title! == keyWord {
                print(notification)
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                print("notification cancelled")
                break
            }
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(reminder)
        }

        self.myReminders.removeAtIndex(index)
        self.tableView.reloadData()
    }
    
    func loadRemindersLocally() {
        let realm = try! Realm()
        let myResults = realm.objects(Reminder.self)
        
        // converting to an array of reminders
        self.myReminders = Array(myResults)
        print(myReminders)
        self.tableView.reloadData()
    
    }
    
    @IBAction func cancelAllNotificationPressed(sender: UIBarButtonItem) {
        self.myReminders.removeAll()
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        self.tableView.reloadData()
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Reminder.self))
        }
    }
    
    
    // MARK: Table View SETUPs

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myReminders.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! ReminderTableViewCell
        
        cell.reminderName?.text = self.myReminders[indexPath.row].title
        guard let time = self.myReminders[indexPath.row].date else {
            return cell
        }
        
        let date = time
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        cell.reminderTime?.text = "\(hour / 10)\(hour % 10):\(minutes / 10)\(minutes % 10)"
        return cell
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteReminder(indexPath.row)
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
}
