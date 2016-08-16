//
//  PillInfoViewController.swift
//  Auyrma
//
//  Created by MacBook on 08.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import RealmSwift

class PillInfoViewController: UIViewController {

    @IBOutlet weak var instructionTextView: UITextView!
    
    var pill: FirebasePill!
    let myColor : UIColor = UIColor( red: 185/255, green: 60/255, blue:60/255, alpha: 1.0 )
    
    let addButtonColor : UIColor = UIColor(red: 88/255, green: 142/255, blue: 183/255, alpha: 1.0)
    var mnn: String!
    var country: String!
    var pillIdOnWeb: Int!
    var price: Int!
    
    var added = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.added = false
        self.title = self.title!.capitalizedString
        
        
        //  ВАЖНОО
        //  вот эту строку надо заменить точнее info старое но вот это новое значение
        let info = self.download("http://biosfera.kz/product/product?product_id=\(self.pillIdOnWeb)")
        
        self.instructionTextView.text = self.deleteHTML(info)
        self.loadPills()
    }
    
    
    func setNavBar(favorite: String) {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Alarm Clock Filled-75-2"), forState: .Normal)
        btn1.frame = CGRectMake(0, 0, 30, 30)
        btn1.addTarget(self, action: #selector(addReminderPressed), forControlEvents: .TouchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        
        let btn2 = UIButton()
        btn2.setImage(UIImage(named: favorite), forState: .Normal)
        btn2.frame = CGRectMake(0, 0, 30, 30)
        btn2.addTarget(self, action: #selector(saveButtonPressed), forControlEvents: .TouchUpInside)
        let item2 = UIBarButtonItem()
        item2.customView = btn2
        self.navigationItem.rightBarButtonItems = [item1,item2]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadPills()
    }
    
    func loadPills() {
        self.added = false
        let realm = try! Realm()
        let realmPills = Array(realm.objects(RealmPill.self))
        for pill in realmPills {
            if pill.name == self.title! {
                self.added = true
                break
            }
        }
        self.setNavBar("Christmas Star-75")
        if added {
            self.setNavBar("Christmas Star Filled-75")
        }
    }
    
    func saveButtonPressed() {
        let realm = try! Realm()
        if self.added == true {
            let realmPills = Array(realm.objects(RealmPill.self))
            for pill in realmPills {
                if pill.name == self.title! {
                    try! realm.write() {
                        realm.delete(pill)
                    }
                    break
                }
            }
            self.added = false
            self.setNavBar("Christmas Star-75")
        } else {
            try! realm.write {
                let pill = RealmPill()
                pill.country = self.country!
                pill.name = self.title!
                pill.mnn = self.mnn!
                realm.add(pill)
            }
            self.added = true
            self.setNavBar("Christmas Star Filled-75")
        }
    }
    
    func download(url: String) -> String{
        
        guard let myurl = NSURL(string: url) else {
            print("Error")
            return ""
        }
        
        // try catch block
        do {
            // downloads the content of URL address
            let text = try String(contentsOfURL: myurl)
            return text
        } catch let error as NSError {
            print("Error \(error)")
        }
        
        return ""
    }
    
    
    func deleteHTML(text: String) -> String {
        var final = ""
        let arrayText = [Character](text.characters)
        let keyword = [Character]("TBODY".characters)
        
        var newStart = 0
        for i in 0 ..< arrayText.count - keyword.count + 1 {
            var match = true
            for j in 0 ..< keyword.count {
                if arrayText[i + j] != keyword[j] {
                    match = false
                    break
                }
            }
            
            if match {
                newStart = i + keyword.count
                break
            }
        }
        
        var i = newStart
        let size = arrayText.count
        var counter = 0
        while i < size {
            
            if arrayText[i] == "+" && arrayText[i + 1] == "7" {
                counter += 1
                if counter > 1 {
                    break
                }
            }
            
            if arrayText[i] == "<" {
                var j = i + 1
                while arrayText[j] != ">" {
                    j = j + 1
                }
                i = j
                final += " "
            } else {
                if arrayText[i] != "&"
                {
                    final += String(arrayText[i])
                }
            }
            
            i = i + 1
        }
        
        //  ВАЖНОО
        //  добавь эту строку
        if final.characters.count > 20000 {
            final = "нету данных"
        }
        
        return final
    }
    
    func addReminderPressed() {
        self.performSegueWithIdentifier("SegueAddReminder", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueAddReminder" {
            let vc = segue.destinationViewController as! ReminderViewController
            vc.placeHolder = "Выпить \(self.title!.capitalizedString)"
        }
    }
}
