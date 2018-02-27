//
//  BaseModel.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BaseRequest:Mappable {
    var url:String { get }
}
