//
//  RateUsViewController.swift
//  Auyrma
//
//  Created by MacBook on 26.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class RateUsViewController: UIViewController {
    
    var url: String = "empty"
    let myColor : UIColor = UIColor(red: 185/255, green: 60/255, blue:60/255, alpha: 1.0 )
    
    @IBAction func rateUsPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.com/us/app/auyrma-poiskovik-analogov/id1137948454?mt=8")!)
    }
    
    @IBOutlet weak var rateUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rateUsButton.backgroundColor = self.myColor
        // Do any additional setup after loading the view.
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
