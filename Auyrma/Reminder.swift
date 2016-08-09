//
//  Reminder.swift
//  Auyrma
//
//  Created by MacBook on 15.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import Foundation
import RealmSwift

class Reminder: Object {
    dynamic var title: String?
    dynamic var notificationId: String?
    dynamic var date: NSDate?
}