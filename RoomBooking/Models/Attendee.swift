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
    var phoneNumber:String = ""
    
    init(name:String, email:String, phoneNumber:String) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name    <- map["name"]
        email   <- map["email"]
        phoneNumber  <- map["number"]
    }
}
