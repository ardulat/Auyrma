//
//  ContentViewController.swift
//  Auyrma
//
//  Created by MacBOOK PRO on 09.08.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var text: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = "fuck it"
    }
    
}
