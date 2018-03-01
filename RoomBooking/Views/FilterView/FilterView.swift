//
//  FilterView.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 3/1/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var txtRoomName: UITextField!
    @IBOutlet weak var switchAvailableNextHour: UISwitch!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var txtCapacity: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actClearBtn(_ sender: UIButton) {
        switchAvailableNextHour.isOn = false
        txtRoomName.text = ""
        txtSize.text = ""
        txtCapacity.text = ""
    }
}
