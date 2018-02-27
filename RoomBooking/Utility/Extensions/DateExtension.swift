//
//  DateExtension.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

extension Date {
    var unixDate:String {
        let timestamp = self.timeIntervalSince1970
        return String(describing: timestamp)
    }
}
