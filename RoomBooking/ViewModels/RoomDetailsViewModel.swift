//
//  RoomDetailsViewModel.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 2/28/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

protocol RoomDetailsViewModelProtocol {
    var room: Dynamic<Room> { get }
    
}

class RoomDetailsViewModel: NSObject, RoomDetailsViewModelProtocol {
    var room: Dynamic<Room>

    init(room:Room) {
        self.room = Dynamic(room)
        super.init()
    }
}

