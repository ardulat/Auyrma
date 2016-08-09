//
//  PharmacyGeoLocation.swift
//  Auyrma
//
//  Created by MacBook on 18.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import Foundation
import RealmSwift

class PharmacyGeoLocation: NSObject {
    var objectId: String?
    var latitude: Double = 0
    var longitude: Double = 0
    var title: String?
    var subtitle: String?
}


class PharmacyGeoLocationForRealm: Object {
    dynamic var objectId: String?
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var title: String?
    dynamic var subtitle: String?
}