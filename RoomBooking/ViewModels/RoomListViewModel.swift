//
//  RoomListViewModel.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

protocol RoomListViewModelProtocol {
    var rooms: Dynamic<[Room]> { get }
    var selectedDate: Dynamic<Date> { get }
    func changeDate(_ date:Date)
    func applyFilters(availableNextHour:Bool, name:String, size:String, capacity:String)
}

class RoomListViewModel: NSObject, RoomListViewModelProtocol {
    
    var selectedDate: Dynamic<Date>
    var rooms: Dynamic<[Room]>
    private var dataService:RoomBookingApi
    private var allRoomsAtDate:[Room] = []
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
    
    private func getRooms() {
        AlertView.show()
        dataService.getRooms(GetRoomsRequest(date: selectedDateString)) { (rooms:[Room]?, error:Error?) in
            if let rooms = rooms {
                self.allRoomsAtDate = rooms
                self.rooms.value = rooms
            }
        AlertView.dismiss()
        }
    }
    
    func changeDate(_ date: Date) {
        self.selectedDate.value = date
        getRooms()
    }

    func applyFilters(availableNextHour:Bool, name:String, size:String, capacity:String) {
        var filteredRooms:[Room] = allRoomsAtDate
        filteredRooms = name.count > 0 ? filteredRooms.filter { $0.name == name } : filteredRooms
        filteredRooms = size.count > 0 ? filteredRooms.filter { $0.size == size + "m²"} : filteredRooms
        filteredRooms = capacity.count > 0 ? filteredRooms.filter { $0.capacity == Int(capacity) } : filteredRooms
        rooms.value = filteredRooms
    }
}
