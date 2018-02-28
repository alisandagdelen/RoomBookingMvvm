//
//  Passes.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 2/28/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

struct Attendee: BaseObject {
    
    var name:String = ""
    var email:String = ""
    var number:String = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name    <- map["name"]
        email   <- map["email"]
        number  <- map["number"]
    }
}
