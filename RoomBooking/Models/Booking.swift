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
    
    init(date:String, timeStart:String, timeEnd:String, title:String, description:String, roomName:String) {
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.title = title
        self.description = description
        self.roomName = roomName
    }
    
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
