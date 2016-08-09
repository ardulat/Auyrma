//
//  RateUsUrl.swift
//  Auyrma
//
//  Created by MacBook on 26.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import Foundation
import RealmSwift

class RateUsUrl: NSObject {
    var objectId: String?
    var url: String?
}

class RateUsUrlForRealm: Object {
    dynamic var url: String?
}

class Prefix: Object {
    dynamic var name: String?
}