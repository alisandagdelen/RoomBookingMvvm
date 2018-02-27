//
//  Room.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

struct Room: BaseObject {
    
    var name:String = ""
    var location:String = ""
    var equipments:[String] = []
    var size:String = ""
    var capacity:Int = 0
    var availableHours:[String] = []
    var imageUrls:[String] = []
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        location <- map["location"]
        equipments <- map["equipment"]
        size <- map["size"]
        capacity <- map["capacity"]
        availableHours <- map["avail"]
        imageUrls <- map["images"]
    }
    
}
