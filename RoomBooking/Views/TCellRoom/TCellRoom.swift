//
//  TCellRoom.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

class TCellRoom: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
