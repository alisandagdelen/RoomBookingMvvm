//
//  BookRoomResponse.swift
//  RoomBooking
//
//  Created by alisandagdelen on 28.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

struct BookRoomResponse: BaseObject {
    
    var success:Bool = false

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        success <- map["success"]
    }
}
