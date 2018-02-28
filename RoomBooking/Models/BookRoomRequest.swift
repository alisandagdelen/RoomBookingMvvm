//
//  BookRoomRequest.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 2/28/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

struct BookRoomRequest: BaseRequest {

    var booking:Booking!
    var attendees:[Attendee]!

    var url: String = {
        return API.SendPassURL
    }()
    
    init(booking:Booking, attendees:[Attendee]) {
        self.booking = booking
        self.attendees = attendees
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        booking     <- map["booking"]
        attendees   <- map["passes"]
    }
    
}
