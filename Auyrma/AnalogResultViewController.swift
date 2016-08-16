//
//  AnalogResultViewController.swift
//  Auyrma
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import SCLAlertView

import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class AnalogResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var titleText: String?
    let backendless = Backendless.sharedInstance()
    var analogs = [FirebasePill]()
    var pillPrices = [Int]()
    var pillIdOnWeb = [Int]()
    var globalMNN = ""
    
    var counterGlobal = 0
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 2, height: 2), type: NVActivityIndicatorType(rawValue: 2)!, color: UIColor.redColor(), padding: 0)
    
    let myColor : UIColor = UIColor( red: 185/255, green: 60/255, blue:60/255, alpha: 1.0)
    
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCloseButton: false
    )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background3.jpg")!)
        
        guard Reachability.isConnectedToNetwork() == true else {
            let alert = SCLAlertView(appearance: self.appearance)
            alert.addButton("Окей", backgroundColor: self.UIColorFromRGB(0xB40431), textColor: UIColor.whiteColor(), showDurationStatus: true) {
                return
            }
            alert.showInfo("Извините!", subTitle: "У вас нет интернета")
            return
        }
        
        self.startSearchingFirebase()
        
        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: -20, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 12)!, color: self.myColor, padding: 0)
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3.0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimation()
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func startSearchingFirebase() {
        let ref = FIRDatabase.database().reference().child("byName/\(self.titleText!)")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            
            if snap.value == nil {
                return
            }
            
            guard let mnn = snap.value!["mnn"]! else {
                return
            }
            
            print(mnn)
            
            self.globalMNN = mnn as! String
            
            let ref2 = FIRDatabase.database().reference().child("byMNN/\(mnn)")
            ref2.observeEventType(.Value) {
                (snap: FIRDataSnapshot) in
                self.analogs.removeAll()
                for (_, b) in snap.value as! [String: AnyObject] {
                    let tempPill = FirebasePill()
                    tempPill.name = b["name"]!! as? String
                    tempPill.country = b["country"]!! as? String
                    tempPill.mnn = b["mnn"]!! as! String
                    self.analogs.append(tempPill)
                    self.pillIdOnWeb.append(0)
                    self.pillPrices.append(-1)
                }
                
                self.activityIndicator.stopAnimation()
                self.tableView.reloadData()
                for i in 0 ..< self.analogs.count {
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        self.pillPrices[i] = self.getPrice(self.analogs[i].name!, index: i)
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                        }
                    }
                }
                return
            }
        }
    }
    
    
    // MARK: TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PillCell", forIndexPath: indexPath) as! PillTableViewCell
        
        let index = indexPath.row
        cell.whichLabel.text = self.analogs[index].country!.capitalizedString
        cell.nameLabel!.text = self.analogs[index].name!.capitalizedString
        cell.backgroundColor = UIColor.whiteColor()
        cell.whichLabel.textColor = UIColor.orangeColor()
        
        // selection background color
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = self.myColor
//        cell.selectedBackgroundView = bgColorView
        
        cell.priceLabel.text = "ищем цену..."
        if self.pillPrices[index] == -1 {
            // -1 means not downloaded
            self.counterGlobal += 1
            print(self.counterGlobal)
        } else {
            if self.pillPrices[index] == 0 {
                cell.priceLabel.text = "нету данных"
            } else {
                cell.priceLabel.text = String(self.pillPrices[index]) + " тг"
            }
        }
        return cell
    }
    
    func getPrice(pill: String, index: Int) -> Int {
        // downloading from web the price of a pill
        let badurl = "http://biosfera.kz/product/search?sort=relevance&search="
        let word = self.prettify(pill)
        let goodurl = "\(badurl)\(word.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!)"
        let text = self.download(goodurl)
        
        // converting to the array of characters
        let textArray = Array(text.lowercaseString.characters)
        let keyword = Array("priceline".lowercaseString.characters)
        let addToCart = Array("addToCart".lowercaseString.characters)
        
        var newStart = 0
        
        // searching for the first price in sale
        var price = 0
        for i in 60000 ..< textArray.count - keyword.count + 1 {
            var match = true
            for j in 0 ..< keyword.count {
                if textArray[i + j] != keyword[j] {
                    match = false
                    break
                }
            }
            
            if match {
                for j in i + keyword.count + 2 ..< textArray.count {
                    newStart = j
                    if textArray[j] == "<" {
                        break
                    }
                    if textArray[j] >= "0" && textArray[j] <= "9" {
                        price = price * 10 + Int(String(textArray[j]))!
                    }
                }
                break
            }
        }
        
        // searching for the id of pill on web page
        
        var id = 0
        for i in newStart ..< textArray.count - keyword.count + 1 {
            var match = true
            for j in 0 ..< addToCart.count {
                if textArray[i + j] != addToCart[j] {
                    match = false
                    break
                }
            }
            
            if match {
                for j in i + addToCart.count ..< textArray.count {
                    newStart = j
                    if textArray[j] == "<" {
                        break
                    }
                    if textArray[j] >= "0" && textArray[j] <= "9" {
                        id = id * 10 + Int(String(textArray[j]))!
                    }
                }
                break
            }
        }
        
        self.pillIdOnWeb[index] = id
        
        // searching for the second price in sale
        var price2 = 0
        for i in newStart ..< textArray.count - keyword.count + 1 {
            var match = true
            for j in 0 ..< keyword.count {
                if textArray[i + j] != keyword[j] {
                    match = false
                    break
                }
            }
            
            if match {
                for j in i + keyword.count + 2 ..< textArray.count {
                    if textArray[j] == "<" {
                        break
                    }
                    if textArray[j] >= "0" && textArray[j] <= "9" {
                        price2 = price2 * 10 + Int(String(textArray[j]))!
                    }
                }
                break
            }
        }
        if price == 0 {
            return price2
        } else
            if price2 == 0 {
                return price
        }
        
        print("\(word) id = \(id)")
        return min(price, price2)
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
    
    
    func prettify(word: String) -> String {
        var final = ""
        var temp = Array(word.characters)
        for i in 0 ..< temp.count {
            if i > 0 && i < temp.count - 1 && temp[i - 1] == " " && temp[i + 1] == " " {
                    continue
            } else
                if i == temp.count - 1 && temp[i - 1] == " " {
                    continue
            }
            final += String(temp[i])
        }
        return final
    }
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SeguePillInfo", sender: indexPath)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SeguePillInfo" {
            let vc = segue.destinationViewController as! PillInfoViewController
            let index = sender as! NSIndexPath
            vc.title = self.analogs[index.row].name!
            vc.mnn = self.analogs[index.row].mnn!
            vc.country = self.analogs[index.row].country!
            vc.price = self.pillPrices[index.row]
            vc.pillIdOnWeb = self.pillIdOnWeb[index.row]
        }
    }

}
