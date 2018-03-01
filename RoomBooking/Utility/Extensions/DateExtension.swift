//
//  DateExtension.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation

extension Date {
    var unixDate:String {
        let timestamp = self.timeIntervalSince1970
        let delimiter = "."
        guard let dateUnix = String(describing: timestamp).components(separatedBy: delimiter).first else { return "" }
        return dateUnix
    }
    
    var callender:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        return dateFormatter.string(from: self)
    }
    
}
