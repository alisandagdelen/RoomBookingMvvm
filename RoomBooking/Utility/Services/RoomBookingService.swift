//
//  RoomBookingService.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

protocol RoomBookingApi {
    func getRooms(_ request:GetRoomsRequest, _ result:@escaping GenericArrayBlock<Room>)
    func postBooking(_ request:BookRoomRequest, _ result:@escaping GenericObjectBlock<BookRoomResponse>)
}

class RoomBookingService: RoomBookingApi {
    
    static let sharedInstance = RoomBookingService()
    
    private init() {
        
    }
    
    func getRooms(_ request: GetRoomsRequest, _ result: @escaping ([Room]?, Error?) -> Void) {
        DataService.sharedInstance.postObjectForObjects(request) { ( rooms:[Room]?, error:Error?) in
            result(rooms, error)
        }
    }
    
    func postBooking(_ request: BookRoomRequest, _ result: @escaping (BookRoomResponse?, Error?) -> Void) {
        DataService.sharedInstance.postObjectForObject(request)  { (response:BookRoomResponse?, error:Error?) in
            result(response,error)
        }
    }
}
