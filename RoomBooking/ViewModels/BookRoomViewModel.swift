//
//  BookRoomViewModel.swift
//  RoomBooking
//
//  Created by alisandagdelen on 28.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

enum InvalidFieldType:String {
    case name             = "Name invalid"
    case email            = "Email invalid"
    case phoneNo          = "Phone Number invalid"
    case title            = "Title invalid"
    case descpription     = "Description invalid"
    case emptyAttendees   = "Attendees empty"
    case existAttendee    = "Attendee already exist"
    case emptyBookingTime = "Booking time empty"
}

protocol BookRoomViewModelProtocol {
    var attendees: Dynamic<[Attendee]> { get }
    var invalidAttendeeFields: Dynamic<[InvalidFieldType]> { get }
    var invalidBookingFields: Dynamic<[InvalidFieldType]> { get }
    var roomName: String { get }
    var availableHours:[String] { get }
    func addAttendee(name:String, email:String, phoneNo:String)
    func selectBookingTime(timeStart:String, timeEnd:String)
    func deleteAttendee(_ attendee:Attendee)
    func bookRoom(title:String, description:String, _ completion: @escaping SuccessBlock)
}

class BookRoomViewModel: NSObject, BookRoomViewModelProtocol {
    
    var invalidAttendeeFields: Dynamic<[InvalidFieldType]>
    var invalidBookingFields: Dynamic<[InvalidFieldType]>
    var attendees: Dynamic<[Attendee]>
    
    var roomName: String {
        return room.name
    }

    var availableHours:[String] {
        return room.availableHours
    }

    private var room:Room!
    private var date:Date!
    private var dataService:RoomBookingApi
    private var beginTime:String!
    private var endTime:String!
    
    init(room:Room, date:Date, dataService:RoomBookingApi = RoomBookingService.sharedInstance) {
        self.room = room
        self.date = date
        self.dataService = dataService
        self.attendees = Dynamic([])
        self.invalidAttendeeFields = Dynamic([])
        self.invalidBookingFields = Dynamic([])
        self.beginTime = ""
        self.endTime = ""
        super.init()
    }
    
    func addAttendee(name:String, email:String, phoneNo:String) {
        if validateAttendeeFields(name: name, email: email, phoneNo: phoneNo) {
            guard let phoneNumber = phoneNo.formattedPhoneNumber else { return }
            let attendee = Attendee(name: name, email: email, phoneNumber: phoneNumber)
            attendees.value.append(attendee)
        }
    }
    
    func deleteAttendee(_ attendee: Attendee) {
        if let index = attendees.value.index(where: { $0.email == attendee.email}) {
            attendees.value.remove(at: index)
        }
    }
    
    func selectBookingTime(timeStart:String, timeEnd:String) {
        let startHour = timeStart.hourIntTuple.hour
        let startMinute = timeStart.hourIntTuple.minute
        let endHour = timeEnd.hourIntTuple.hour
        let endMinute = timeEnd.hourIntTuple.minute
        guard let beginDateUnix = formatBookingDate(hour: startHour, minute: startMinute) else { return }
        guard let endDateUnix = formatBookingDate(hour: endHour, minute: endMinute) else { return }
        beginTime = beginDateUnix
        endTime = endDateUnix
    }
    
    func bookRoom(title: String, description: String, _ completion: @escaping SuccessBlock) {
        if validateBookingFields(title: title, description: description) {
            let booking = Booking(date: date.unixDate, timeStart: beginTime, timeEnd: endTime, title: title, description: description, roomName: room.name)
            let request = BookRoomRequest(booking: booking, attendees: attendees.value)
            dataService.postBooking(request, { (response, error) in
                if let response = response {
                    completion(response.success)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    private func formatBookingDate(hour:Int, minute:Int) -> String? {
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: date)
        dateComponents.month = Calendar.current.component(.month, from: date)
        dateComponents.day = Calendar.current.component(.day, from: date)
        dateComponents.hour = hour
        dateComponents.minute = minute
        return Calendar.current.date(from: dateComponents)?.unixDate
    }
    
    private func validateAttendeeFields(name:String, email:String, phoneNo:String) -> Bool {
        var invalidFields:[InvalidFieldType] = []
        
        if !email.isValidEmail {
            invalidFields.append(.email)
        }
        if !phoneNo.isValidPhoneNo {
            invalidFields.append(.phoneNo)
        }
        if (name.count < 2) {
            invalidFields.append(.name)
        }
        if let _ = attendees.value.index(where: { $0.email == email}) {
            invalidFields.append(.existAttendee)
        }
        invalidAttendeeFields.value = invalidFields
        let result = invalidAttendeeFields.value.count == 0 ? true : false
        return result
    }
    
    private func validateBookingFields(title:String, description:String) -> Bool {
        var invalidFields:[InvalidFieldType] = []

        if (title.count < 1) {
            invalidFields.append(.title)
        }
        if (description.count < 1) {
            invalidFields.append(.descpription)
        }
        if (attendees.value.count < 1) {
            invalidFields.append(.emptyAttendees)
        }
        if (endTime.count < 1 && beginTime.count < 1) {
            invalidFields.append(.emptyBookingTime)
        }
        invalidBookingFields.value = invalidFields
        let result = invalidBookingFields.value.count == 0 ? true : false
        return result
    }
}
