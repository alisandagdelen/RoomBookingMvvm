//
//  StringExtension.swift
//  RoomBooking
//
//  Created by alisandagdelen on 28.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import PhoneNumberKit

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
}
