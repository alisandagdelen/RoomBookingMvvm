//
//  GetRoomsRequest.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetRoomsRequest: BaseRequest {
    
    var date:String
    var url: String = {
        return API.GetRoomsURL
    }()
    
    init(date:String) {
        self.date = date
    }
    
    init?(map: Map) {
        self.init(map: map)
    }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
    }
    
  
    
}
