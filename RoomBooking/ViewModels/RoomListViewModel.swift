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
    var selectedDate: Dynamic<Date> { get }
}

class RoomListViewModel: NSObject, RoomListViewModelProtocol {
    
    var selectedDate: Dynamic<Date>
    var rooms: Dynamic<[Room]>
    private var dataService:RoomBookingApi
    
    private var selectedDateString:String {
        return selectedDate.value.unixDate
    }
    
    init(date: Date = Date(), dataService:RoomBookingApi = RoomBookingService.sharedInstance) {
        self.dataService = dataService
        self.selectedDate = Dynamic(date)
        self.rooms = Dynamic([])
        super.init()
        self.getRooms()
    }
    
    func getRooms() {
        dataService.getRooms(GetRoomsRequest(date: selectedDateString)) { (rooms:[Room]?, error:Error?) in
            if let rooms = rooms {
                self.rooms.value = rooms
            }
        }
    }
    
    func changeDate(_ date: Date) {
        self.selectedDate.value = date
        getRooms()
    }
}
