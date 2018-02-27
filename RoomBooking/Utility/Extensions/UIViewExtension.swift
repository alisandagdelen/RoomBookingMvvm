//
//  UIViewExtension.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

extension UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static var fromNib: UIView? {
        let nib = UINib(nibName:nibName, bundle:nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView
        return view
    }
}
