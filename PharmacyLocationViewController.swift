//
//  PharmacyLocationViewController.swift
//  Auyrma
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import GoogleMaps
import RealmSwift
import Firebase


class PharmacyLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var pharmacies = [PharmacyGeoLocationForRealm]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        self.searchForPharmacyFromFirebase()
        //self.searchForPharmacyAsync()
    }
    
    func searchForPharmacyFromFirebase() {
        let ref = FIRDatabase.database().reference().child("pharmacy/almaty")
        ref.observeEventType(.Value) {
            (snap: FIRDataSnapshot) in
            for (_, b) in snap.value as! [String: AnyObject] {
                print(b["name"] as! String)
                let coordinate = CLLocationCoordinate2D(latitude: Double(b["latitude"] as! String)!, longitude: Double(b["longitude"] as! String)!)
                
                let annotation = Apteka(title: b["name"] as! String, coordinate: coordinate)
                annotation.subtitle = b["telephone"] as? String
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func searchForPharmacyLocally() {
        // clearing out before adding new ones
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        
        // adding locally saved pharmacy locations
        let realm = try! Realm()
        
        self.pharmacies = Array(realm.objects(PharmacyGeoLocationForRealm.self))
        
        for pharmacy in pharmacies {
            let annotation = Apteka(title: pharmacy.title!, coordinate: CLLocationCoordinate2D(latitude: pharmacy.latitude, longitude: pharmacy.longitude))
            annotation.subtitle = pharmacy.subtitle
            self.mapView.addAnnotation(annotation)
        }
        
        print("hello")
        
        print(self.mapView.annotations)
        
//        {
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = item.placemark.coordinate
//                annotation.title = item.name
//                print(annotation.coordinate)
//                self.mapView.addAnnotation(annotation)
//        }
    }
    
    // MARK: Backendless
    
    func searchForPharmacyAsync() {
        let dataStore = Backendless.sharedInstance().data.of(PharmacyGeoLocation.ofClass())
        
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let contacts = result.getCurrentPage()
                let realm = try! Realm()
                for obj in contacts {
                    let obj2 = obj as! PharmacyGeoLocation
                    let forRealm = PharmacyGeoLocationForRealm()
                    forRealm.title = obj2.title
                    forRealm.objectId = obj2.objectId!
                    forRealm.latitude = obj2.latitude
                    forRealm.longitude = obj2.longitude
                    forRealm.subtitle = obj2.subtitle
                    
                    var toAdd = true
                    
                    for temp in self.pharmacies {
                        if temp.objectId! == forRealm.objectId! {
                            toAdd = false
                            break
                        }
                    }
                    
                    if toAdd {
                        try! realm.write {
                            realm.add(forRealm)
                        }
                    }
                    print("\(obj)")
                }
                self.searchForPharmacyLocally()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    
    func download(url: String) -> String {
        
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        //self.searchForPharmacyLocally()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error \(error)")
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
