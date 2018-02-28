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

class RoomDetailsVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collectionPhotos: UICollectionView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblEquipments: UILabel!
    weak var delegate:RoomDetailsVCDelegate?

    private var dataSource: CollectionViewDataSource<CCellRoomPhotos, String>!
    var roomDetailsViewModel: RoomDetailsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        collectionPhotos.delegate = self
        collectionPhotos.backgroundColor = self.view.backgroundColor
        collectionPhotos.register(UINib(nibName: CCellRoomPhotos.nibName, bundle: nil), forCellWithReuseIdentifier: CCellRoomPhotos.nibName)
        fillUI()
        
        // Do any additional setup after loading the view.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actBtnClose(_ sender: UIButton) {
        removeAnimate()
    }
    
    func showAnimate() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
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
