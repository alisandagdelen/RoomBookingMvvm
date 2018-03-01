//
//  StringExtension.swift
//  RoomBooking
//
//  Created by alisandagdelen on 28.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import PhoneNumberKit

protocol TimeString {
    
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    var formattedPhoneNumber: String? {
        let phoneNumberKit = PhoneNumberKit()
        guard let phoneNumber = try? phoneNumberKit.parse(self) else { return nil }
        let phoneNumbere164 = phoneNumberKit.format(phoneNumber, toType: .e164)
        return phoneNumbere164
    }
    
    var isValidPhoneNo: Bool {
        guard let _ = self.formattedPhoneNumber else { return false }
        return true
    }
    
    var hoursTuple: (begin:String, end:String) {
        let hours = self.replacingOccurrences(of: " ", with: "")
        let hoursArray = hours.components(separatedBy: "-")
        return (begin:hoursArray.first ?? "", end: hoursArray.last ?? "")
    }
    
    var hoursIntTuple: (begin:Int, end:Int) {
        let hours = self.replacingOccurrences(of: " ", with: "")
        let hoursArray = hours.components(separatedBy: "-")
        let beginHourString = hoursArray.first?.replacingOccurrences(of: ":", with: "")
        let endHourString = hoursArray.last?.replacingOccurrences(of: ":", with: "")
        guard let beginHour = Int(beginHourString ?? "") else { return (begin: 0, end: 0)}
        guard let endHour = Int(endHourString ?? "") else { return (begin: 0, end: 0)}
        return (begin: beginHour, end: endHour)
    }
    
    var hourIntTuple: (hour:Int, minute:Int) {
        let hoursArray = self.components(separatedBy: ":")
        guard let hour = Int(hoursArray.first ?? "") else { return (hour:0, minute:0)}
        guard let minute = Int(hoursArray.last ?? "") else { return (hour:0, minute:0)}
        return (hour:hour, minute:minute)
    }
}

extension String :TimeString {
    
}
