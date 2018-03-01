//
//  UIColorExtension.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 3/1/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

extension UIColor {
    static var oneaBlue: UIColor {
            return UIColor(hex: "00A0DB")
    }
    
    static var oneadarkBlue: UIColor {
        return UIColor(hex: "362A83")
    }
    
    static var oneaPurple: UIColor {
        return UIColor(hex: "A01F80")
    }
    
    static var oneaPink: UIColor {
        return UIColor(hex: "E40274")
    }
    
    static var oneaRed: UIColor {
        return UIColor(hex: "E31E2F")
    }
    
    static var oneaOrange: UIColor {
        return UIColor(hex: "EC7B23")
    }
    
    static var oneaYellow: UIColor {
        return UIColor(hex: "FFE900")
    }
    
    static var oneaGreen: UIColor {
        return UIColor(hex: "9ABD36")
    }
    
    static var oneaDarkGreen: UIColor {
        return UIColor(hex: "009547")
    }
    
    static var oneaBlueHex: UInt {
        return 0x00A0DB
    }
    
    static var oneadarkBlueHex: UInt {
        return 0x362A83
    }
    
    static var oneaPurpleHex: UInt {
        return 0xA01F80
    }
    
    static var oneaPinkHex: UInt {
        return 0xE40274
    }
    
    static var oneaRedHex: UInt {
        return 0xE31E2F
    }
    
    static var oneaOrangeHex: UInt {
        return 0xEC7B23
    }
    
    static var oneaYellowHex: UInt {
        return 0xFFE900
    }
    
    static var oneaGreenHex: UInt {
        return 0x9ABD36
    }
    
    static var oneaDarkGreenHex: UInt {
        return 0x009547
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
