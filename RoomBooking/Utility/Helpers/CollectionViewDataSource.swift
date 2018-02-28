//
//  CollectionViewDataSource.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 2/28/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

class CollectionViewDataSource <CellType: UICollectionViewCell, Model>: NSObject, UICollectionViewDataSource {
    
    var cellIdentifier: String!
    var items: [Model]!
    var configureCell: (CellType,Model) -> ()
    
    init(cellIdentifier: String, items: [Model], configureCell: @escaping (CellType, Model) -> ()) {
        self.configureCell = configureCell
        super.init()
        
        self.cellIdentifier = cellIdentifier
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  self.cellIdentifier!, for: indexPath) as? CellType else { return UICollectionViewCell() }
        let object = self.items[indexPath.row]
        configureCell(cell, object)
        return cell
    }
}

