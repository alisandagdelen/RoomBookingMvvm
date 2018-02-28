//
//  Booking.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 2/28/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

struct Booking: BaseObject {
    
    var date:String = ""
    var timeStart:String = ""
    var timeEnd:String = ""
    var title:String = ""
    var description:String = ""
    var roomName:String = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        date         <- map["date"]
        timeStart    <- map["time_start"]
        timeEnd      <- map["time_end"]
        title        <- map["title"]
        description  <- map["description"]
        roomName     <- map["room"]
    }
}
