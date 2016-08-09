//
//  MyPillViewController.swift
//  Auyrma
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

class MyPillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pills = [RealmPill]()
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 2, height: 2), type: NVActivityIndicatorType(rawValue: 2)!, color: UIColor.redColor(), padding: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background3.jpg")!)
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.title = "Мои лекарства"
        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: -20, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 12)!, color: UIColor.redColor(), padding: 0)
        
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3.0)
        
        self.tableView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimation()
        self.loadPills()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadPills()
    }
    
    func loadPills() {
        let realm = try! Realm()
        let results = realm.objects(RealmPill.self)
        self.pills = Array(results)
        self.tableView.reloadData()
        self.activityIndicator.stopAnimation()
    }
    
    // MARK: TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PillCell", forIndexPath: indexPath) as! PillTableViewCell
        
        cell.whichLabel.text = self.pills[indexPath.row].country!.capitalizedString
        cell.nameLabel!.text = self.pills[indexPath.row].name!.capitalizedString
        cell.backgroundColor = UIColor.whiteColor()
        cell.whichLabel.textColor = UIColor.orangeColor()

        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deletePill(indexPath.row)
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // REALM deletion
    
    func deletePill(index: Int) {
        let pill = self.pills[index]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(pill)
        }
        self.pills.removeAtIndex(index)
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SegueMyPills", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueMyPills" {
            let vc = segue.destinationViewController as! PillInfoViewController
            let index = sender as! NSIndexPath
            vc.title = self.pills[index.row].name
            vc.country = self.pills[index.row].country
            vc.mnn = self.pills[index.row].mnn
        }
    }

}
