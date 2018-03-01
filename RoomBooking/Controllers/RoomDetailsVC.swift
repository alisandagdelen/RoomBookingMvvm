//
//  RoomDetails.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit
import SDWebImage

protocol RoomDetailsVCDelegate:class {
    func bookRoom(_ room:Room)
}

class RoomDetailsVC: BasePopupVC {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collectionPhotos: UICollectionView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblEquipments: UILabel!
    @IBOutlet weak var btnBookRoom: UIButton!
    weak var delegate:RoomDetailsVCDelegate?
    
    private var dataSource: CollectionViewDataSource<CCellRoomPhotos, String>!
    var roomDetailsViewModel: RoomDetailsViewModelProtocol?
    
    enum CloseType {
        case quit, book
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimate()
        setupUI()
        fillUI()
    }
    
    func fillUI() {
        
        guard let roomDetailsViewModel = roomDetailsViewModel else { return }
        let imageUrls = roomDetailsViewModel.room.value.imageUrls
        
        self.dataSource = CollectionViewDataSource<CCellRoomPhotos, String>(cellIdentifier: CCellRoomPhotos.nibName, items: imageUrls) { (cell, url) in
            let fullUrl = API.BaseURL + url
            cell.imgRoomPhoto.sd_setImage(with: URL(string: fullUrl), placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }
        self.collectionPhotos.dataSource = self.dataSource
        self.collectionPhotos.reloadData()
        lblName.text = roomDetailsViewModel.room.value.name
        lblSize.text = roomDetailsViewModel.room.value.size
        lblCapacity.text = "\(roomDetailsViewModel.room.value.capacity)"
        lblEquipments.text = roomDetailsViewModel.room.value.equipments.joined(separator: ", ")
        lblLocation.text = roomDetailsViewModel.room.value.location
    }
    
    func setupUI() {
        collectionPhotos.delegate = self
        collectionPhotos.register(UINib(nibName: CCellRoomPhotos.nibName, bundle: nil), forCellWithReuseIdentifier: CCellRoomPhotos.nibName)
        collectionPhotos.backgroundColor = UIColor.white
        btnBookRoom.backgroundColor = UIColor.oneaDarkGreen
        
    }

    @IBAction func actBtnClose(_ sender: UIButton) {
        removeAnimate(closeType: .quit)
    }
    
    @IBAction func actBookRoom(_ sender: UIButton) {
        removeAnimate(closeType: .book)
    }
    
    func removeAnimate(closeType: CloseType) {
        
        guard let roomDetailsViewModel = roomDetailsViewModel else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
                if closeType == .book {
                    self.delegate?.bookRoom(roomDetailsViewModel.room.value)
                }
            }
        });
    }
}

extension RoomDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = (collectionViewSize.width/3.0) - 10
        collectionViewSize.height = collectionViewSize.width
        return collectionViewSize
    }
}
