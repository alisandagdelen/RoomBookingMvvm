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
    
    // MARK: Properties
    
    var room: Dynamic<Room>
    
    // MARK: Initializer
    
    init(room:Room) {
        self.room = Dynamic(room)
        super.init()
    }
}

