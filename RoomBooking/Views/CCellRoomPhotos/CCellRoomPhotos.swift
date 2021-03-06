//
//  CCellRoomPhotos.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 2/28/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

class CCellRoomPhotos: UICollectionViewCell {
    
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var imgRoomPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            viewBorder.backgroundColor = UIColor.oneaGreen
    }
}
