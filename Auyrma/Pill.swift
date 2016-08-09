//
//  Pill.swift
//  Auyrma
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import Foundation
import GoogleMaps
import RealmSwift

class RealmPill: Object {
    dynamic var name: String?
    dynamic var mnn: String?
    dynamic var country: String?
    dynamic var price: String?
    dynamic var pillIdOnWeb: String?
}

class Apteka: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}


class FirebasePill: NSObject {
    var name: String?
    var country: String?
    var mnn: String?
    var pillIdOnWeb: Int?
}