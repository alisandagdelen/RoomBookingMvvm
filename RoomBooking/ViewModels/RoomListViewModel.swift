//
//  RoomListViewModel.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

protocol RoomListViewModelProtocol {
    func changeDate(_ date:Date)
    var rooms: Dynamic<[Room]> { get }
}

class RoomListViewModel: NSObject, RoomListViewModelProtocol {
  
    
    var rooms: Dynamic<[Room]>
    private var dataService:RoomBookingApi
    private var date:Date
    
    private var dateString:String {
        return date.unixDate
    }
    
    init(date: Date = Date(), dataService:RoomBookingApi = RoomBookingService.sharedInstance) {
        self.date = date
        self.dataService = dataService
        self.rooms = Dynamic([])
        super.init()
        self.getRooms()
    }
    
    func getRooms() {
        dataService.getRooms(GetRoomsRequest(date: dateString)) { (rooms:[Room]?, error:Error?) in
            if let rooms = rooms {
                self.rooms.value = rooms
            }
        }
    }
    
    func changeDate(_ date: Date) {
        self.date = date
        getRooms()
    }
}
