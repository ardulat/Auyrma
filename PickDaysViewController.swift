//
//  PickDaysViewController.swift
//  Auyrma
//
//  Created by MacBook on 09.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit

class PickDaysViewController: UIViewController {

    
    var delegate: WeekdayDelegate!
    
    @IBOutlet weak var monSwitch: UISwitch!
    @IBOutlet weak var tueSwitch: UISwitch!
    @IBOutlet weak var wedSwitch: UISwitch!
    @IBOutlet weak var thuSwitch: UISwitch!
    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satSwitch: UISwitch!
    @IBOutlet weak var sunSwitch: UISwitch!
    
    var weekdays = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.weekdays.append(self.monSwitch.on)
        self.weekdays.append(self.tueSwitch.on)
        self.weekdays.append(self.wedSwitch.on)
        self.weekdays.append(self.thuSwitch.on)
        self.weekdays.append(self.friSwitch.on)
        self.weekdays.append(self.satSwitch.on)
        self.weekdays.append(self.sunSwitch.on)
        self.delegate.updateWeekdays(self.weekdays)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
